import 'package:flutter/material.dart';
import 'package:imat_app/pages/main_view.dart';
import 'package:imat_app/widgets/checkout_progress_bar.dart';

class Confirmation extends StatelessWidget {
  const Confirmation({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          const CheckoutProgressBar(currentStep: 4),
      
    Expanded (
      child: Center(
        child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: const Color(0xFF3FA7D6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              "TACK FÖR DITT KÖP DINOSAURIE!!!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            const Text(
              "En orderbekräftelse har skickats till ditt mejl.\n"
              "Ditt kvitto har sparats på ditt iMat-konto",
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

                  child: const Text("GÅ HEM!"),
                ),

                ElevatedButton(
                  onPressed: () {
                    print("lets go gambling");
                  },

                  child: const Text("GAMBLIN’"),
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