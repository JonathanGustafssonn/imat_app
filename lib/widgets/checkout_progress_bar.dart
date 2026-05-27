import 'package:flutter/material.dart';

const Color _accentGreen = Color.fromARGB(255, 197, 243, 129);

class CheckoutProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Function(int step) onStepTapped;

  const CheckoutProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,

      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 24),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(totalSteps, (index) {
              final stepNumber = index + 1;
              final isActive = stepNumber == currentStep;
              final isDone = stepNumber < currentStep;

              return GestureDetector(
                onTap: () => onStepTapped(stepNumber),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive || isDone
                                ? _accentGreen
                                : Colors.grey.shade300,
                            border: Border.all(
                              color: isActive ? Colors.black : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: isDone
                                ? const Icon(Icons.check, size: 22)
                                : Text(
                                    "$stepNumber",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        if (stepNumber != totalSteps)
                          Container(
                            width: 4,
                            height: 60,
                            color: isDone
                                ? _accentGreen
                                : Colors.grey.shade300,
                          ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _label(stepNumber),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isActive
                                ? Colors.black
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  String _label(int step) {
    switch (step) {
      case 1:
        return "Varukorg";
      case 2:
        return "Leverans";
      case 3:
        return "Betalning";
      default:
        return "Steg $step";
    }
  }
}