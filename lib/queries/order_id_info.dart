import 'package:flutter/material.dart';

class OrderIdInfoQuery {
  static const String name = 'Extractor de Información de Órdenes';
  
  static const String query = '''
SELECT 
  order_module_order.id,
  order_module_order.on_hold,
  order_module_order.status,
  order_module_order.storage_id,
  order_module_order.in_worker,
  order_module_marketplaceorder.id,
  order_module_marketplaceorder.reference,
  order_module_marketplaceorder.marketplace_pk
FROM order_module_order 
JOIN order_module_marketplaceorder
  ON order_module_marketplaceorder.id = order_module_order.marketplace_order_id
WHERE ({conditions});
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

  static String generateQuery(List<String> references) {
    if (references.isEmpty) return '';

    final List<String> likeStatements = references
        .map((ref) => "order_module_marketplaceorder.reference LIKE '$ref%'")
        .toList();

    return query.replaceAll('{conditions}', likeStatements.join(' OR '));
  }
}