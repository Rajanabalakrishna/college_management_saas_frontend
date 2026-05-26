import 'package:college_management_saas/core/constants/api_constants.dart';
import 'package:college_management_saas/home_screen.dart';
//import 'package:college_management_saas/payments/razorpay_payment_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../razorpay_flutter_service.dart';

class CollegeAccessScreen extends StatefulWidget {
  const CollegeAccessScreen({super.key});

  @override
  State<CollegeAccessScreen> createState() => _CollegeAccessScreenState();
}

class _CollegeAccessScreenState extends State<CollegeAccessScreen> {
  final _domainController = TextEditingController(text: 'testcollege.edu');
  final _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  late final RazorpayPaymentService _razorpay;

  bool _loading = false;
  bool _confirmingPayment = false;
  bool _paymentSuccess = false;

  String? _collegeName;
  List<dynamic> _plans = [];
  Map<String, dynamic>? _selectedPlan;

  @override
  void initState() {
    super.initState();

    _razorpay = RazorpayPaymentService(
      onSuccess: (_) => _afterPaymentSuccess(),
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
    _domainController.dispose();
    _razorpay.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final domain = _domainController.text.trim().toLowerCase();

    if (domain.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter college domain')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final statusRes = await _dio.get('/public/colleges/$domain/status');
      final data = statusRes.data['data'];

      _collegeName = data['collegeName'];

      if (data['subscriptionActive'] == true) {
        _openHome();
        return;
      }

      final plansRes = await _dio.get('/public/subscription/plans');
      final plans = plansRes.data['data'] as List;

      setState(() {
        _plans = plans;
        _selectedPlan = plans.isNotEmpty ? plans.first : null;
      });

      if (plans.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No subscription plans found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to check college: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pay() async {
    if (_selectedPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a plan')),
      );
      return;
    }

    final domain = _domainController.text.trim().toLowerCase();

    setState(() => _loading = true);

    try {
      final res = await _dio.post(
        '/public/colleges/$domain/subscription/create-order',
        data: {'plan_id': _selectedPlan!['id']},
      );

      final data = res.data['data'];

      _razorpay.open(
        keyId: data['keyId'],
        orderId: data['orderId'],
        amount: data['amount'],
        name: data['collegeName'] ?? 'College SaaS',
        description: 'College SaaS subscription', email: '', contact: '',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to start payment: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _afterPaymentSuccess() async {
    if (!mounted) return;

    setState(() {
      _paymentSuccess = true;
      _confirmingPayment = true;
      _loading = false;
    });

    final domain = _domainController.text.trim().toLowerCase();

    for (var i = 0; i < 8; i++) {
      await Future.delayed(const Duration(seconds: 2));

      try {
        final res = await _dio.get('/public/colleges/$domain/status');
        final active = res.data['data']['subscriptionActive'] == true;

        if (active) {
          if (!mounted) return;
          _openHome();
          return;
        }
      } catch (_) {}
    }

    if (!mounted) return;

    setState(() => _confirmingPayment = false);
  }

  void _openHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CampusExploreScreen()),
    );
  }

  String _money(int paise) {
    return 'Rs.${(paise / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    if (_paymentSuccess) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF16A34A),
                      size: 72,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Payment successful',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _confirmingPayment
                          ? 'Activating your college. This usually takes a few seconds.'
                          : 'You can continue to the main screen now.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_confirmingPayment) ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 18),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: _openHome,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Continue to Home',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final showingPlans = _plans.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.account_balance_rounded,
                    size: 56,
                    color: Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    showingPlans
                        ? 'Activate ${_collegeName ?? 'College'}'
                        : 'College Access',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    showingPlans
                        ? 'Choose a test subscription plan to unlock this college.'
                        : 'Enter your college domain to check access.',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 26),
                  TextField(
                    controller: _domainController,
                    enabled: !showingPlans && !_loading,
                    decoration: InputDecoration(
                      labelText: 'College Domain',
                      hintText: 'testcollege.edu',
                      prefixIcon: const Icon(Icons.language_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  if (showingPlans) ...[
                    const SizedBox(height: 22),
                    ..._plans.map((plan) {
                      final selected = _selectedPlan?['id'] == plan['id'];
                      final amount = plan['amount_paise'] as int;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: _loading
                              ? null
                              : () => setState(() => _selectedPlan = plan),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFFEFF6FF)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFFE5E7EB),
                                width: selected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: plan['id'],
                                  groupValue: _selectedPlan?['id'],
                                  onChanged: _loading
                                      ? null
                                      : (_) => setState(
                                        () => _selectedPlan = plan,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    plan['name'] ?? 'Subscription Plan',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Text(
                                  _money(amount),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 26),
                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      onPressed: _loading
                          ? null
                          : showingPlans
                          ? _pay
                          : _continue,
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(showingPlans ? 'Pay & Unlock College' : 'Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}