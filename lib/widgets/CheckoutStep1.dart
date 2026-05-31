import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/pages/main_page_searched.dart';
import 'package:imat_app/widgets/checkoutBoxes.dart';
import 'package:provider/provider.dart';

const Color _accentGreen = Color.fromARGB(255, 197, 243, 129);

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

    final totalPrice = cart.items.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.amount),
    );

    final Map<int, Product> savedMap = {};

    for (final p in iMat.favorites) {
      savedMap[p.productId] = p;
    }

    for (final order in iMat.orders) {
      for (final item in order.items) {
        savedMap[item.product.productId] = item.product;
      }
    }

    final savedProducts = savedMap.values.toList();

    return Center(
      child: SizedBox(
        width: 950,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Kassa",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CheckoutSection(
                        title: "Dina Varor",
                        child: Column(
                          children: [
                            SizedBox(
                              height: 350,
                              child: Scrollbar(
                                thumbVisibility: true,
                                child: ListView(
                                  children: cart.items.map((item) {
                                    final itemTotal =
                                        item.product.price * item.amount;

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.product.name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                const SizedBox(height: 8),

                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.remove),
                                                      onPressed: () {
                                                        iMat.shoppingCartUpdate(
                                                          item,
                                                          delta: -1,
                                                        );
                                                      },
                                                    ),

                                                    Text(
                                                      "${item.amount.toInt()} st",
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),

                                                    IconButton(
                                                      icon:
                                                          const Icon(Icons.add),
                                                      onPressed: () {
                                                        iMat.shoppingCartUpdate(
                                                          item,
                                                          delta: 1,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          Text(
                                            "${itemTotal.toStringAsFixed(0)} kr",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Totalt: ${totalPrice.toStringAsFixed(0)} kr",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      CheckoutSection(
                        title: "Sparade & Tidigare Köpta Varor",
                        child: SizedBox(
                          height: 360,
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: GridView.builder(
                              padding: const EdgeInsets.all(4),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: savedProducts.length,
                              itemBuilder: (context, index) {
                                final product = savedProducts[index];

                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 212, 212, 212),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          child: iMat.getImage(product),
                                        ),

                                        const SizedBox(height: 10),

                                        Text(
                                          product.name,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        Text(
                                          "${product.price.toStringAsFixed(2)} kr",
                                          style: const TextStyle(
                                            color: _accentGreen,
                                            fontSize: 13,
                                          ),
                                        ),

                                        const Spacer(),

                                        SizedBox(
                                          height: 30,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _accentGreen,
                                              foregroundColor: Colors.black,
                                              padding: EdgeInsets.zero,
                                              textStyle: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              iMat.shoppingCartAdd(
                                                ShoppingItem(product, 1),
                                              );
                                            },
                                            child: const Text("Lägg till"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
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
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MainPageSearched(),
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