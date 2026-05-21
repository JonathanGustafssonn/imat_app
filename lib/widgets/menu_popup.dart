import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/category_button.dart';
import 'package:provider/provider.dart';

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

  Widget _buildCategoryButton(
    String label, 
    IconData icon, 
    ProductCategory category,
    ) {
      return CategoryButton(
      label: label,
      icon: icon,
      hoverColor: const Color(0xFF97C64E),

      onTap: () {

        var iMat = context.read<ImatDataHandler>();

        if (category == ProductCategory.UNDEFINED){
          iMat.selectAllProducts();
        } else {
           var products = iMat.findProductsByCategory(category);
            iMat.selectSelection(products);
        }
        Navigator.pop(context);
      }
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
                        highlightColor: const Color.fromARGB(0, 0, 0, 0),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // KATEGORIKNAPPAR
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildCategoryButton("Alla produkter", Icons.store, ProductCategory.UNDEFINED,),
                          _buildCategoryButton("Kött", Icons.restaurant_menu, ProductCategory.MEAT,),
                          _buildCategoryButton("Grönsaker", Icons.eco, ProductCategory.VEGETABLE_FRUIT,),
                          _buildCategoryButton("Frukt", Icons.apple, ProductCategory.FRUIT,),
                          _buildCategoryButton("Mejeri", Icons.local_drink, ProductCategory.DAIRIES,),
                          _buildCategoryButton("Bröd", Icons.bakery_dining, ProductCategory.BREAD,),
                          _buildCategoryButton("Dryck", Icons.local_cafe, ProductCategory.COLD_DRINKS,),
                          _buildCategoryButton("Snacks", Icons.fastfood, ProductCategory.SWEET,),
                          _buildCategoryButton("Bär", Icons.ac_unit, ProductCategory.BERRY,),
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
