import 'package:flutter/material.dart';

class CheckoutProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CheckoutProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: (currentStep) / totalSteps,
      color: const Color(0xFF97C64E),
      backgroundColor: Colors.grey[300],
    );
  }
}