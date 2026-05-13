import 'package:flutter/material.dart';
import 'package:imat_app/widgets/category_button.dart';

class MenuPopup extends StatefulWidget {
  final String title;
  final String message;

  const MenuPopup({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  State<MenuPopup> createState() => _MenuPopupState();
}

class _MenuPopupState extends State<MenuPopup>
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
      begin: const Offset(-1.0, 0.0),
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

  Widget _buildCategoryButton(String label, IconData icon) {
    return CategoryButton(
      label: label,
      icon: icon,
      onTap: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // MÖRK OVERLAY
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(color: Colors.black.withOpacity(0.5)),
        ),

        // TEXT I MITTEN
        const Center(
          child: Text(
            "Du kan stänga menyn genom att \n klicka utanför den eller på krysset.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),

        // SLIDE-IN PANEL FRÅN VÄNSTER
        Align(
          alignment: Alignment.centerLeft,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: 350,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                border: Border.all(color: Colors.black, width: 5),
              ),
              padding: const EdgeInsets.all(25),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITEL + KRYSS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.close, size: 32, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // KATEGORIKNAPPAR
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildCategoryButton("Kött", Icons.restaurant_menu),
                          _buildCategoryButton("Grönsaker", Icons.eco),
                          _buildCategoryButton("Frukt", Icons.apple),
                          _buildCategoryButton("Mejeri", Icons.local_drink),
                          _buildCategoryButton("Bröd", Icons.bakery_dining),
                          _buildCategoryButton("Dryck", Icons.local_cafe),
                          _buildCategoryButton("Snacks", Icons.fastfood),
                          _buildCategoryButton("Frysvaror", Icons.ac_unit),
                        ],
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
