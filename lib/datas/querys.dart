import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masirana/queries/change_substorage_unit.dart';
import 'package:masirana/queries/dispatch.dart';
import 'package:masirana/queries/in_process_in_worker.dart';
import 'package:masirana/queries/order_id_info.dart';
import 'package:masirana/queries/change_storage_unit.dart';
import 'package:masirana/queries/dispatch_motive.dart';
import 'package:masirana/queries/order_id_x_guia.dart';
import 'package:masirana/queries/order_ids_ligadas.dart';
import 'package:masirana/queries/status_change.dart';


class Queries {
  static final List<Map<String, String>> allQueries = [
    {
      'name': OrderIdInfoQuery.name,
      'query': OrderIdInfoQuery.query,
    },
    {
      'name': ChangeStorageUnitQuery.name,
      'query': ChangeStorageUnitQuery.query,
    },
    {
      'name': ChangeSubstorageUnitQuery.name,
      'query': ChangeSubstorageUnitQuery.query,
    },
    {
      'name': DispatchOrderProductQuery.name,
      'query': DispatchOrderProductQuery.query,
    },
    {
      'name': DispatchMotiveQuery.name,
      'query': DispatchMotiveQuery.query,
  },
  {
      'name': StatusChangeQuery.name,
      'query': StatusChangeQuery.query,
  },
  {
      'name': InProcessInWorkerQuery.name,
      'query': InProcessInWorkerQuery.query,
  },
  {
      'name': OrderIdXGuiaQuery.name,
      'query': OrderIdXGuiaQuery.query,
  },
  {
      'name': OrderIdsLigadasQuery.name,
      'query': OrderIdsLigadasQuery.query,
  },
  ];
}

class QueryBuilderWeb extends StatefulWidget {
  const QueryBuilderWeb({super.key});

  @override
  State<QueryBuilderWeb> createState() => _QueryBuilderWebState();
}

class _QueryBuilderWebState extends State<QueryBuilderWeb> {
  final List<String> references = [];
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController orderIdsController = TextEditingController();
  String generatedQuery = '';
  String selectedQuery = Queries.allQueries.first['query']!;
  String selectedQueryName = Queries.allQueries.first['name']!;
  String selectedStorageId = '';
  String selectedSubstorageId = '';
  List<Map<String, dynamic>> queryResults = [];
  bool showResults = false;
  bool isDispatched = true;
  bool isInWorker = true;
  int selectedDispatchStatus = 4;
  int selectedStatus = 0;


  void processReferences() {
    if (referenceController.text.isEmpty) return;

    final newRefs = referenceController.text
        .split(RegExp(r'[\s,]+'))
        .where((ref) => ref.isNotEmpty)
        .toList();

    setState(() {
      references.clear();
      references.addAll(newRefs);
      referenceController.clear();
      _generateQuery();
    });
  }

  void _generateQuery() {
  if (selectedQueryName == OrderIdInfoQuery.name) {
    setState(() {
      generatedQuery = OrderIdInfoQuery.generateQuery(references);
    });
  } else if (selectedQueryName == ChangeStorageUnitQuery.name) {
    setState(() {
      generatedQuery = ChangeStorageUnitQuery.generateQuery(
        selectedStorageId,
        orderIdsController.text,
      );
    });
  } else if (selectedQueryName == ChangeSubstorageUnitQuery.name) {
    setState(() {
      generatedQuery = ChangeSubstorageUnitQuery.generateQuery(
        selectedSubstorageId,
        orderIdsController.text,
      );
    });
  } else if (selectedQueryName == DispatchOrderProductQuery.name) {
    setState(() {
      generatedQuery = DispatchOrderProductQuery.generateQuery(
        orderIdsController.text,
        isDispatched,
      );
    });
  } else if (selectedQueryName == DispatchMotiveQuery.name) {
    setState(() {
      generatedQuery = DispatchMotiveQuery.generateQuery(
        orderIdsController.text,
        selectedDispatchStatus,
      );
    });
  } else if(selectedQueryName == StatusChangeQuery.name) {
    setState(() {
      generatedQuery = StatusChangeQuery.generateQuery(
        orderIdsController.text,
        selectedStatus,
      );
    });
  } else if(selectedQueryName == InProcessInWorkerQuery.name) {
    setState(() {
      generatedQuery = InProcessInWorkerQuery.generateQuery(
        orderIdsController.text,
        isInWorker,
      );
    });
  } else if(selectedQueryName == OrderIdXGuiaQuery.name) {
    setState(() {
      generatedQuery = OrderIdXGuiaQuery.generateQuery(
        orderIdsController.text,
      );
    });
  } else if(selectedQueryName == OrderIdsLigadasQuery.name) {
    setState(() {
      generatedQuery = OrderIdsLigadasQuery.generateQuery(
        orderIdsController.text,
      );
    });
  }
}


  void executeQuery() {
    setState(() {
      showResults = true;
      queryResults = references.map((ref) => {
        'order_id': '${references.indexOf(ref) + 1}',
        'on_hold': false,
        'status': 'pending',
        'reference': ref,
        'storage_id': 'ST${references.indexOf(ref) + 100}',
        'marketplace_pk': 'MPK${references.indexOf(ref) + 200}'
      }).toList();
    });
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: generatedQuery));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Query copiado al portapapeles'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Armador de queries para kirana'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown for Query Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seleccionar Query:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: selectedQueryName,
                        isExpanded: true,
                        onChanged: (value) {
                          final query = Queries.allQueries
                              .firstWhere((element) => element['name'] == value);
                          setState(() {
                            selectedQueryName = query['name']!;
                            selectedQuery = query['query']!;
                            generatedQuery = ''; // Limpiar query anterior
                          });
                        },
                        items: Queries.allQueries.map((query) {
                          return DropdownMenuItem<String>(
                            value: query['name'],
                            child: Text(query['name']!),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Conditional Input Section based on selected query
              if (selectedQueryName == OrderIdInfoQuery.name)
                OrderIdInfoQuery.buildInputSection(
                  referenceController: referenceController,
                  onProcess: processReferences,
                ),

              if (selectedQueryName == ChangeStorageUnitQuery.name)
                ChangeStorageUnitQuery.buildInputSection(
                  selectedStorageId: selectedStorageId,
                  orderIdsController: orderIdsController,
                  onStorageSelected: (value) {
                    if (value != null) {
                      setState(() {
                        selectedStorageId = value;
                        _generateQuery();
                      });
                    }
                  },
                  onGenerate: _generateQuery,
                ),

              if (selectedQueryName == ChangeSubstorageUnitQuery.name)
                ChangeSubstorageUnitQuery.buildInputSection(
                  selectedSubstorageId: selectedSubstorageId,
                  orderIdsController: orderIdsController,
                  onSubstorageSelected: (value) {
                    if (value != null) {
                      setState(() {
                        selectedSubstorageId = value;
                        _generateQuery();
                      });
                    }
                  },
                  onGenerate: _generateQuery,
                ),
              
              if (selectedQueryName == DispatchOrderProductQuery.name)
                   DispatchOrderProductQuery.buildInputSection(
                    orderIdsController: orderIdsController,
                    isDispatched: isDispatched,
                    onDispatchValueChanged: (value) {
                      setState(() {
                        isDispatched = value;
                        _generateQuery();
                      });
                    },
                    onGenerate: _generateQuery,
                  ),

              if (selectedQueryName == DispatchMotiveQuery.name)
               DispatchMotiveQuery.buildInputSection(
                 orderIdsController: orderIdsController,
                 selectedStatus: selectedDispatchStatus,
                 onStatusChanged: (value) {
                   if (value != null) {
                     setState(() {
                       selectedDispatchStatus = value;
                       _generateQuery();
                     });
                   }
                 },
                 onGenerate: _generateQuery,
               ),

              if (selectedQueryName == StatusChangeQuery.name)
                StatusChangeQuery.buildInputSection(
                  orderIdsController: orderIdsController,
                  selectedStatus: selectedStatus,
                  onStatusSelected: (value) {
                    if (value != null) {
                      setState(() {
                        selectedStatus = value;
                        _generateQuery();
                      });
                    }
                  },
                  onGenerate: _generateQuery,
                ),

              if (selectedQueryName == InProcessInWorkerQuery.name)
                InProcessInWorkerQuery.buildInputSection(
                  orderIdsController: orderIdsController,
                  isInWorker: isInWorker,
                  onInWorkerValueChanged: (value) {
                    setState(() {
                      isInWorker = value;
                      _generateQuery();
                    });
                  },
                  onGenerate: _generateQuery,
                ),

              if (selectedQueryName == OrderIdXGuiaQuery.name)
                OrderIdXGuiaQuery.buildInputSection(
                  referenceController: orderIdsController,
                  onProcess: _generateQuery,
                ),


              if (selectedQueryName == OrderIdsLigadasQuery.name)
                OrderIdsLigadasQuery.buildInputSection(
                  referenceController: orderIdsController,
                  onProcess: _generateQuery,
                ),

              const SizedBox(height: 16),

              // Query Display
              if (generatedQuery.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Query SQL Generado:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () => _copyToClipboard(context),
                              tooltip: 'Copiar al portapapeles',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SelectableText(
                            generatedQuery,
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}