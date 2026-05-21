import 'package:flutter/material.dart';
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
      begin: const Offset(1.0, 0.0), // start off-screen to the right
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // DARK OVERLAY
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),

        const Center(
          child: Text(
            "Du kan stänga menyn genom att \n klicka utanför den eller på krysset.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
              ),
            ),
          ),

        // SLIDE-IN PANEL
        Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: 250,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
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
                  IconButton(
                    icon: const Icon(Icons.close, size: 32, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    widget.message,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Spacer(),

        Align(
             alignment: Alignment.bottomRight,
             child: ElevatedButton.icon(
               style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.green,
                 padding: const EdgeInsets.symmetric(
                   horizontal: 20,
                   vertical: 14,
                ),
                 shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                 ),
                ),

                 onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder:(context) => const CheckoutPage(),
                   ),
                   );
                   },

                   icon: const Icon(Icons.shopping_cart_checkout),
                   label: const Text(
                     "Kassan",
                     style: TextStyle(fontSize: 18),
                    ),
                 ),
            ),
      ],
    );
  }
}