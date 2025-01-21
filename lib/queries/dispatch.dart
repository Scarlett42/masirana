import 'package:flutter/material.dart';

class DispatchOrderProductQuery {
  static const String name = 'Modificar Dispatch Status';
  
  static const String query = '''
UPDATE order_module_orderproduct 
SET dispatched = {dispatch_value} 
WHERE order_id IN ({ids});
''';

  static Widget buildInputSection({
    required TextEditingController orderIdsController,
    required bool isDispatched,
    required Function(bool) onDispatchValueChanged,
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
                  'Estado Dispatch:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: isDispatched,
                  onChanged: onDispatchValueChanged,
                ),
                Text(
                  isDispatched ? 'TRUE' : 'FALSE',
                  style: TextStyle(
                    color: isDispatched ? Colors.green : Colors.red,
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

  static String generateQuery(String orderIdsText, bool isDispatched) {
    if (orderIdsText.isEmpty) return '';

    final cleanIds = orderIdsText
        .split(RegExp(r'[\s,]+'))
        .where((id) => id.isNotEmpty)
        .map((id) => "'${id.trim()}'")
        .join(',');

    return query
        .replaceAll('{dispatch_value}', isDispatched.toString().toUpperCase())
        .replaceAll('{ids}', cleanIds);
  }
}