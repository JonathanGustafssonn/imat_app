import 'package:flutter/material.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/pages/main_page_searched.dart';
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

    return Center(
      child: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Kassa",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 197, 243, 129),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            CheckoutSection(
                              title: "Dina Varor",
                              child: SizedBox(
                                height: 500, 
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  child: ListView(
                                    children: cart.items.map((item) {
                                      return ListTile(
                                        title: Text(item.product.name),
                                        subtitle: Text("${item.amount} st"),
                                        trailing: Text("${item.product.price} kr"),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          children: [
                            CheckoutSection(
                              title: "Sparade Varor",
                              child: SizedBox(
                                height: 500,
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  child: ListView(
                                    children: const [
                                      ListTile(
                                        title: Text("Ej implementerat ännu"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   ElevatedButton(
                    onPressed: (){
                      Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                      builder: (context) => const MainPageSearched(),
                      ),
                      (route) => false,
                      );
                    },
                    child: const Text("Tillbaka"),
                  ),
                  ElevatedButton(
                    onPressed: onNext,
                    child: const Text("Fortsätt"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}