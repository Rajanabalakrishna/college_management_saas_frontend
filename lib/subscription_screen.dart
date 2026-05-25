import 'package:college_management_saas/home_screen.dart';
//import 'package:college_management_saas/payments/razorpay_payment_service.dart';
import 'package:college_management_saas/providers/dio_provider.dart';
import 'package:college_management_saas/razorpay_flutter_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  late RazorpayPaymentService _razorpay;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _razorpay = RazorpayPaymentService(
      onSuccess: (_) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CampusExploreScreen()),
        );
      },
      onError: (_) {
        if (!mounted) return;
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

  Future<void> _pay(int amountPaise) async {
    setState(() => _loading = true);

    try {
      final dio = ref.read(dioProvider);

      final plansRes = await dio.get('/payments/subscription/plans');
      final plans = plansRes.data['data'] as List;

      final plan = plans.firstWhere(
            (p) => p['amount_paise'] == amountPaise,
        orElse: () => null,
      );

      if (plan == null) {
        throw Exception('Plan not found');
      }

      final orderRes = await dio.post(
        '/payments/subscription/create-order',
        data: {'plan_id': plan['id']},
      );

      final data = orderRes.data['data'];

      _razorpay.open(
        keyId: data['keyId'],
        orderId: data['orderId'],
        amount: data['amount'],
        name: 'AcademyHQ',
        description: 'SaaS subscription', email: '', contact: '',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to start payment: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activate App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Pay test subscription to unlock assignments, fees, results and other sections.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : () => _pay(100),
              child: const Text('Pay Rs.1 Test Plan'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : () => _pay(500),
              child: const Text('Pay Rs.5 Test Plan'),
            ),
          ],
        ),
      ),
    );
  }
}