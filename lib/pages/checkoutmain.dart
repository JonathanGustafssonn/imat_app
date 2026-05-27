import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/credit_card.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/pages/confirmation.dart';
import 'package:imat_app/widgets/CheckoutStep1.dart';
import 'package:imat_app/widgets/CheckoutStep2.dart';
import 'package:imat_app/widgets/CheckoutStep3.dart';
import 'package:imat_app/widgets/checkout_progress_bar.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int currentStep = 0;

  Customer? customer;
  CreditCard? card;

  void nextStep() {
    final iMat = context.read<ImatDataHandler>();

    if (currentStep < 2) {
      setState(() => currentStep++);
    } else {
      iMat.placeOrder();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Confirmation()),
      );
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  void goToStep(int step) {
    setState(() {
      currentStep = step - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget;

    switch (currentStep) {
      case 0:
        currentWidget = CheckoutStep1(onNext: nextStep, onBack: previousStep);
        break;

      case 1:
        currentWidget = CheckoutStep2(
          onNext: nextStep,
          onBack: previousStep,
          onCustomerChanged: (c) => customer = c,
          onCardChanged: (c) => card = c,
        );
        break;

      case 2:
        currentWidget = CheckoutStep3(
          onFinish: nextStep,
          onBack: previousStep,
          customer: customer,
          card: card,
        );
        break;

      default:
        currentWidget = CheckoutStep1(onNext: nextStep, onBack: previousStep);
    }

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 260,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: CheckoutProgressBar(
                    currentStep: currentStep + 1,
                    totalSteps: 3,
                    onStepTapped: goToStep,
                  ),
                ),
              ),

              const SizedBox(width: 24),

              Expanded(
                child: currentWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}