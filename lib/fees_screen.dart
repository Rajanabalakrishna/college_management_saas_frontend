//import 'package:college_management_saas/payments/razorpay_payment_service.dart';
import 'package:college_management_saas/providers/dio_provider.dart';
import 'package:college_management_saas/razorpay_flutter_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeesScreen extends ConsumerStatefulWidget {
  const FeesScreen({super.key});

  @override
  ConsumerState<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends ConsumerState<FeesScreen> {
  late RazorpayPaymentService _razorpay;
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadInvoices();

    _razorpay = RazorpayPaymentService(
      onSuccess: (_) {
        setState(() => _future = _loadInvoices());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment received. Receipt will appear after confirmation.')),
        );
      },
      onError: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment failed')),
        );
      },
    );
  }

  @override
  void dispose() {
    _razorpay.dispose();
    super.dispose();
  }

  Future<List<dynamic>> _loadInvoices() async {
    final res = await ref.read(dioProvider).get('/payments/fees/me');
    return res.data['data'] as List<dynamic>;
  }

  Future<void> _pay(String invoiceId) async {
    final res = await ref.read(dioProvider).post('/payments/fees/$invoiceId/pay');
    final data = res.data['data'];

    _razorpay.open(
      keyId: data['keyId'],
      orderId: data['orderId'],
      amount: data['amount'],
      name: 'AcademyHQ',
      description: 'College fee payment', email: '', contact: '',
    );
  }

  String _money(int paise) => 'Rs.${(paise / 100).toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fees')),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final invoices = snapshot.data!;
          if (invoices.isEmpty) {
            return const Center(child: Text('No fee invoices found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: invoices.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final invoice = invoices[index] as Map<String, dynamic>;
              final total = invoice['total_amount_paise'] as int;
              final paid = invoice['paid_amount_paise'] as int;
              final balance = total - paid;
              final status = invoice['status'] as String;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Invoice: ${invoice['invoice_no']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Total: ${_money(total)}'),
                      Text('Paid: ${_money(paid)}'),
                      Text('Balance: ${_money(balance)}'),
                      Text('Status: $status'),
                      const SizedBox(height: 12),
                      if (balance > 0)
                        ElevatedButton(
                          onPressed: () => _pay(invoice['id']),
                          child: const Text('Pay Now'),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}