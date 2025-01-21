import 'package:flutter/material.dart';
import 'package:masirana/datas/statuses.dart';

class StatusChangeQuery {
  static const String name = 'Cambiar Estado (Status Change)';

  static const String query = '''
UPDATE order_module_order 
SET status = {status} 
WHERE id IN ({ids});
''';

  static Widget buildInputSection({
    required TextEditingController orderIdsController,
    required int selectedStatus,
    required Function(int?) onStatusSelected,
    required VoidCallback onGenerate,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seleccionar Estado:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<int>(
              value: selectedStatus,
              isExpanded: true,
              hint: const Text('Seleccione un estado'),
              onChanged: onStatusSelected,
              items: Statuses.allStatuses.map((status) {
                return DropdownMenuItem<int>(
                  value: status['id'],
                  child: Text(status['name']!),
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

  static String generateQuery(String orderIdsText, int selectedStatus) {
    if (orderIdsText.isEmpty) return '';

    final cleanIds = orderIdsText
        .split(RegExp(r'[\s,]+'))
        .where((id) => id.isNotEmpty)
        .map((id) => "'${id.trim()}'")
        .join(',');

    return query
        .replaceAll('{status}', selectedStatus.toString())
        .replaceAll('{ids}', cleanIds);
  }
}