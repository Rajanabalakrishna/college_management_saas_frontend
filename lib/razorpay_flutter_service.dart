import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentService {
  final Razorpay _razorpay = Razorpay();

  RazorpayPaymentService({
    required void Function(PaymentSuccessResponse) onSuccess,
    required void Function(PaymentFailureResponse) onError,
  }) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
  }

  void open({
    required String keyId,
    required String orderId,
    required int amount,
    required String name,
    required String description,
    required String email,
    required String contact,
  }) {
    _razorpay.open({
      'key': keyId,
      'order_id': orderId,
      'amount': amount,
      'currency': 'INR',
      'name': name,
      'description': description,
      'prefill': {'email': email, 'contact': contact},
    });
  }

  void dispose() => _razorpay.clear();
}