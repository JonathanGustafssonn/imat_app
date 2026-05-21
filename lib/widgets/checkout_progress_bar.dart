import 'package:flutter/material.dart';

class CheckoutProgressBar extends StatelessWidget {

  final int currentStep;

  const CheckoutProgressBar({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      color: const Color(0xFF81D7FF),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),

      child: Column(
        children: [

          //Text(
            //"Steg $currentStep / 3",
            //style: const TextStyle(
             // fontSize: 18,
              //fontWeight: FontWeight.bold,
            //),
          //),

          const SizedBox(height: 6),

          Row(
            children: List.generate(3, (index) {

              Color color;

              if (currentStep == 4){
                color = Colors.green;
              }

              if (index < currentStep -1){
                color = Colors.green;
              }

              else if (index == currentStep - 1) {
                color = Colors.yellow;
              }

              else {
                color = Colors.grey[300]!;
              }

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 10,

                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}