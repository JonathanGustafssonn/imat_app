
import 'package:flutter/material.dart';

class Confirmation extends StatelessWidget {
  const Confirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF34B5F0),
        title: const Text("iMat"),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFF81D7FF),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Column(
              children: [
                const Text("Steg 3 / 3"),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: 1.0,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                  minHeight: 10,
                ),
              ],
            ),
          ),

          Expanded(
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue[200],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          child: const Text(
                            "GÅ HEM!",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue[200],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          onPressed: () {
                            print("lets go gambling, cashing!!!!!");
                          },
                          child: const Text(
                            "GAMBLIN’",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ],
                    )
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