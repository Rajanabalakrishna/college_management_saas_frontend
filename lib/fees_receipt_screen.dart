import 'package:college_management_saas/providers/dio_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeeReceiptScreen extends ConsumerWidget {
  const FeeReceiptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dio = ref.watch(dioProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fee Receipts')),
      body: FutureBuilder(
        future: dio.get('/payments/fees/me'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final invoices = snapshot.data!.data['data'] as List;
          final receipts = invoices
              .expand((invoice) => (invoice['receipts'] as List? ?? []))
              .toList();

          if (receipts.isEmpty) {
            return const Center(child: Text('No receipts generated yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: receipts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final receipt = receipts[index] as Map<String, dynamic>;
              final amount = receipt['amount_paise'] as int;

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text(receipt['receipt_no']),
                  subtitle: Text('Amount: Rs.${(amount / 100).toStringAsFixed(2)}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}