import 'package:flutter/material.dart';
import 'package:imat_app/widgets/CheckoutStep1.dart';
import 'package:imat_app/widgets/CheckoutStep2.dart';
import 'package:imat_app/widgets/CheckoutStep3.dart';
import 'package:imat_app/widgets/checkout_progress_bar.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {

  int currentStep = 0;

  void nextStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget currentWidget;

    switch (currentStep) {
      case 0:
        currentWidget = CheckoutStep1();
        break;

      case 1:
        currentWidget = CheckoutStep2();
        break;

      case 2:
        currentWidget = CheckoutStep3();
        break;

      default:
        currentWidget = CheckoutStep1();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),

      body: Column(
        children: [

          CheckoutProgressBar(
            currentStep: currentStep + 1,
          ),

          Expanded(
            child: currentWidget,
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                if (currentStep > 0)
                  ElevatedButton(
                    onPressed: previousStep,
                    child: const Text("Tillbaka"),
                  ),

                ElevatedButton(
                  onPressed: nextStep,
                  child: Text(
                    currentStep == 2
                      ? "Betala"
                      : "Nästa",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}