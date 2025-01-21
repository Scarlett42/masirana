import 'package:flutter/material.dart';

class OrderIdXGuiaQuery {
  static const String name = 'Extractor de Ids de Órdenes por Guía de Envío';

  static const String query = '''
  SELECT id
  FROM order_module_order
  WHERE tracking_code IN ({ids});
  ''';
  static Widget buildInputSection({
    required TextEditingController referenceController,
    required VoidCallback onProcess,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pegue las referencias separadas por espacios:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: referenceController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Ejemplo: 4880054242 4230054163 5410054499',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onProcess,
              child: const Text('Procesar Referencias'),
            ),
          ],
        ),
      ),
    );
  }

  static String generateQuery(String orderIdsText) {
    if (orderIdsText.isEmpty) return '';

    final cleanIds = orderIdsText
        .split(RegExp(r'[\s,]+'))
        .where((id) => id.isNotEmpty)
        .map((id) => "'${id.trim()}'")
        .join(',');

    return query
        .replaceAll('{ids}', cleanIds);
  }
}