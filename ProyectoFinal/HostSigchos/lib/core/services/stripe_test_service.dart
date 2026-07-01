import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeTestResult {
  const StripeTestResult({
    required this.reference,
    required this.status,
    required this.message,
  });

  final String reference;
  final String status;
  final String message;

  bool get isSuccessful => status == 'succeeded';
}

class StripeTestService {
  static const String testCardNumber = '4242424242424242';
  static const String testExpiry = '12/34';
  static const String testCvc = '123';

  String get publishableKey => dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';

  bool get isConfigured =>
      publishableKey.startsWith('pk_test_') &&
      (dotenv.env['STRIPE_TEST_MODE'] ?? 'true').toLowerCase() == 'true';

  Future<StripeTestResult> confirmEducationalPayment({
    required double amount,
    required String cardNumber,
    required String expiry,
    required String cvc,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!isConfigured) {
      return const StripeTestResult(
        reference: 'stripe_test_not_configured',
        status: 'failed',
        message: 'Stripe no está configurado en modo de prueba.',
      );
    }

    final normalizedCard = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (normalizedCard != testCardNumber ||
        expiry.trim() != testExpiry ||
        cvc.trim() != testCvc) {
      return const StripeTestResult(
        reference: 'stripe_test_declined',
        status: 'failed',
        message: 'Usa los datos de prueba de Stripe mostrados en pantalla.',
      );
    }

    final cents = (amount * 100).round();
    final random = Random.secure().nextInt(900000) + 100000;

    return StripeTestResult(
      reference: 'pi_test_${DateTime.now().millisecondsSinceEpoch}_$random',
      status: 'succeeded',
      message:
          'Pago simulado aprobado en Stripe Test por ${(cents / 100).toStringAsFixed(2)}.',
    );
  }
}
