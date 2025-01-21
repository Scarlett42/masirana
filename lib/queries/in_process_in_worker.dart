import 'package:flutter/material.dart';

class InProcessInWorkerQuery {
  static const String name = 'Modificar In Process (In Worker) Status';
  
  static const String query = '''
-- cambias de TRUE a FALSE para liberarla, usar los ids de la 6ta columna del query "order ids info"
UPDATE order_module_order 
SET in_worker = {in_worker_value} 
WHERE marketplace_order_id IN ({ids});
''';

static Widget buildInputSection({
    required TextEditingController orderIdsController,
    required bool isInWorker,
    required Function(bool) onInWorkerValueChanged,
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
                  'Estado In Worker:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: isInWorker,
                  onChanged: onInWorkerValueChanged,
                ),
                Text(
                  isInWorker ? 'TRUE' : 'FALSE',
                  style: TextStyle(
                    color: isInWorker ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
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

  static String generateQuery(String orderIdsText, bool isInWorker) {
    if (orderIdsText.isEmpty) return '';

    final cleanIds = orderIdsText
        .split(RegExp(r'[\s,]+'))
        .where((id) => id.isNotEmpty)
        .map((id) => "'${id.trim()}'")
        .join(',');

    return query
        .replaceAll('{in_worker_value}', isInWorker.toString().toUpperCase())
        .replaceAll('{ids}', cleanIds);

  }

}