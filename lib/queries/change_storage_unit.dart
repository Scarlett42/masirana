import 'package:flutter/material.dart';
import 'package:masirana/datas/bodegas.dart';

class ChangeStorageUnitQuery {
  static const String name = 'Asignar Bodega (Change Storage Unit)';
  
  static const String query = '''
UPDATE order_module_order 
SET storage_id = '{storage_id}' 
WHERE id IN ({ids});
''';

  static Widget buildInputSection({
    required String selectedStorageId,
    required TextEditingController orderIdsController,
    required Function(String?) onStorageSelected,
    required VoidCallback onGenerate,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seleccionar Bodega:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedStorageId.isEmpty ? null : selectedStorageId,
              isExpanded: true,
              hint: const Text('Seleccione una bodega'),
              onChanged: onStorageSelected,
              items: Bodegas.allBodegas.map((bodega) {
                return DropdownMenuItem<String>(
                  value: bodega['id'],
                  child: Text(bodega['name']!),
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

  static String generateQuery(String selectedStorageId, String orderIdsText) {
    if (selectedStorageId.isEmpty || orderIdsText.isEmpty) return '';

    final cleanIds = orderIdsText
        .split(RegExp(r'[\s,]+'))
        .where((id) => id.isNotEmpty)
        .map((id) => "'${id.trim()}'")
        .join(',');

    return query
        .replaceAll('{storage_id}', selectedStorageId)
        .replaceAll('{ids}', cleanIds);
  }
}