import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/pages/checkoutmain.dart';

class ShoppingCartPopup extends StatefulWidget {
  final String title;
  final String message;

  const ShoppingCartPopup({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  State<ShoppingCartPopup> createState() => _ShoppingCartPopupState();
}

class _ShoppingCartPopupState extends State<ShoppingCartPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCartItem(ShoppingItem item, ImatDataHandler iMat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Row(
        children: [
          // Produktbild
          SizedBox(
            width: 55,
            height: 55,
            child: iMat.getImage(item.product),
          ),

          const SizedBox(width: 14),

          // Namn och pris
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "${item.total.toStringAsFixed(2)} kr",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Minus-knapp
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 28, color: Colors.red),
            onPressed: () {
              setState(() {
                iMat.shoppingCartUpdate(item, delta: -1);
              });
            },
          ),

          // Mängd
          Text(
            item.amount.toStringAsFixed(0),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          // Plus-knapp
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28, color: Colors.green),
            onPressed: () {
              setState(() {
                iMat.shoppingCartUpdate(item, delta: 1);
              });
            },
          ),

          // Ta bort
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 26),
            onPressed: () {
              setState(() {
                iMat.shoppingCartRemove(item);
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    var cart = iMat.getShoppingCart();

    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(color: Colors.black.withOpacity(0.5)),
        ),

        Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: 400,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                border: Border.all(color: Colors.black, width: 5),
              ),
              padding: const EdgeInsets.all(25),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titel och kryss
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          color: Colors.black,
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.close, size: 34, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Varukorgslista
                  Expanded(
                    child: cart.items.isEmpty
                        ? const Center(
                            child: Text(
                              "Din varukorg är tom.",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          )
                        : ListView(
                            children: cart.items
                                .map((item) => _buildCartItem(item, iMat))
                                .toList(),
                          ),
                  ),

                  const SizedBox(height: 10),

                  // Totalpris
                  Text(
                    "Totalt: ${iMat.shoppingCartTotal().toStringAsFixed(2)} kr",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Töm varukorg
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        final shouldClear = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return WillPopScope(
                              onWillPop: () async => false,
                              child: AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: const Text(
                                  "Bekräfta",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: const Text(
                                  "Är du säker på att du vill tömma?",
                                  style: TextStyle(fontSize: 16),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text(
                                      "Ångra",
                                      style: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text(
                                      "Jag är säker, töm",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                        if (shouldClear == true) {
                          setState(() {
                            iMat.shoppingCartClear();
                          });
                        }
                      },
                      child: const Text(
                        "Töm varukorg",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Kassa-knapp
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutPage(),
                          ),
                        );
                      },

                      icon: const Icon(Icons.shopping_cart_checkout, size: 24),
                      label: const Text(
                        "Gå till kassan",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}