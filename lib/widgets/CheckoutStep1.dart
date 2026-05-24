import 'package:flutter/material.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/checkoutBoxes.dart';
import 'package:provider/provider.dart';

class CheckoutStep1 extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CheckoutStep1({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final cart = iMat.getShoppingCart();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("Kassa", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

          Expanded(
            child: ListView(
              children: [
                CheckoutSection(
                  title: "Dina Varor",
                  child: Column(
                    children: cart.items.map((item) {
                      return ListTile(
                        title: Text(item.product.name),
                        subtitle: Text("${item.amount} st"),
                        trailing: Text("${item.product.price} kr"),
                      );
                    }).toList(),
                  ),
                ),

                CheckoutSection(
                  title: "Sparade varor",
                  child: const Text("Ej implementerat ännu"),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(onPressed: onBack, child: const Text("Tillbaka")),
              ElevatedButton(onPressed: onNext, child: const Text("Fortsätt")),
            ],
          ),
        ],
      ),
    );
  }
}