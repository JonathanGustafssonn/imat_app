import 'package:flutter/material.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/pages/main_view.dart';
import 'package:imat_app/widgets/checkout_progress_bar.dart';
import 'package:provider/provider.dart';

class Confirmation extends StatelessWidget {
  const Confirmation({super.key});

  @override
  Widget build(BuildContext context) {
    final extras = context.watch<ImatDataHandler>().getExtras();
    final date = extras["deliveryDate"];
    final time = extras["deliveryTime"];

    return Scaffold(
      body: Column(
        children: [
          CheckoutProgressBar(
            currentStep: 4,
            totalSteps: 4,
            onStepTapped: (step) {}
            ),
      
    Expanded (
      child: Center(
        child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 197, 243, 129),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              "Tack för ditt köp <3",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),
            Text(
              "En orderbekräftelse har skickats till din mejl.\n"
              "Ditt kvitto har sparats på ditt iMat-konto\n"
              "Leverans: " 
              "${date != null ? 
              DateTime.parse(date).toLocal().toString().split(' ')[0]
               : 'Ej valt'} "
              "kl. ${time ?? 'Ej valt'}",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                      builder: (context) => const MainView(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text("Gå tillbaka till start sidan"),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    ),
        ],
      ),
    );
  }
}