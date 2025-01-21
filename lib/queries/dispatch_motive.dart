import 'package:flutter/material.dart';

class DispatchMotiveQuery {
  static const String name = 'Modificar Dispatch Status Motivo';
  
  static const String query = '''
UPDATE order_module_orderproduct 
SET dispatch_status = {status_value} 
WHERE order_id IN ({ids});
''';

  static final List<Map<String, dynamic>> statusOptions = [
    {'value': 1, 'label': 'Pendiente'},
    {'value': 2, 'label': 'Confirmado'},
    {'value': 3, 'label': 'Original'},
    {'value': 4, 'label': 'Ignorado'},
  ];

  static Widget buildInputSection({
    required TextEditingController orderIdsController,
    required int selectedStatus,
    required Function(int?) onStatusChanged,
    required VoidCallback onGenerate,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dispatch Status:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: selectedStatus,
                  onChanged: onStatusChanged,
                  items: statusOptions.map((status) {
                    return DropdownMenuItem<int>(
                      value: status['value'],
                      child: Text(status['label']),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'IDs de Órdenes (separados por espacio o coma):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: orderIdsController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'ej: id1, id2, id3',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onGenerate,
              child: const Text('Generar Query'),
            ),
          ],
        ),
      ),
    );
  }

  static String generateQuery(String orderIdsText, int statusValue) {
    if (orderIdsText.isEmpty) return '';

    final cleanIds = orderIdsText
        .split(RegExp(r'[\s,]+'))
        .where((id) => id.isNotEmpty)
        .map((id) => "'${id.trim()}'")
        .join(',');

    return query
        .replaceAll('{status_value}', statusValue.toString())
        .replaceAll('{ids}', cleanIds);
  }
}