import 'package:flutter/material.dart';
import 'package:masirana/datas/subbodegas.dart';

class ChangeSubstorageUnitQuery {
  static const String name = 'Asignar Sub-Bodega (Change Substorage Unit)';
  
  static const String query = '''
UPDATE order_module_order 
SET substorage_id = '{substorage_id}' 
WHERE id IN ({ids});
''';

  static Widget buildInputSection({
    required String selectedSubstorageId,
    required TextEditingController orderIdsController,
    required Function(String?) onSubstorageSelected,
    required VoidCallback onGenerate,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seleccionar Sub-Bodega:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedSubstorageId.isEmpty ? null : selectedSubstorageId,
              isExpanded: true,
              hint: const Text('Seleccione una sub-bodega'),
              onChanged: onSubstorageSelected,
              items: Subbodegas.allSubbodegas.map((subbodega) {
                return DropdownMenuItem<String>(
                  value: subbodega['id'],
                  child: Text(subbodega['name']!),
                );
              }).toList(),
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

  static String generateQuery(String selectedSubstorageId, String orderIdsText) {
    if (selectedSubstorageId.isEmpty || orderIdsText.isEmpty) return '';

    final cleanIds = orderIdsText
        .split(RegExp(r'[\s,]+'))
        .where((id) => id.isNotEmpty)
        .map((id) => "'${id.trim()}'")
        .join(',');

    return query
        .replaceAll('{substorage_id}', selectedSubstorageId)
        .replaceAll('{ids}', cleanIds);
  }
}