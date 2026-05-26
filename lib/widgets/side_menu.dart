import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/category_button.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  ProductCategory selectedCategory = ProductCategory.UNDEFINED;

  Widget _buildCategoryButton(
    BuildContext context,
    String label,
    IconData icon,
    ProductCategory category,
  ) {
    bool isSelected = selectedCategory == category;

    return CategoryButton(
      label: label,
      icon: icon,
      hoverColor: const Color(0xFF97C64E),

      isSelected: isSelected,

      onTap: () {
        setState(() {
          selectedCategory = category;
        });

        var iMat = context.read<ImatDataHandler>();

        iMat.addExtra("currentCategory", label);
        iMat.addExtra("currentSubCategory", label);
        

        if (category == ProductCategory.UNDEFINED) {
          iMat.selectAllProducts();
          iMat.addExtra("currentCount", iMat.products.length.toString());
        } else {
          var products =
              iMat.findProductsByCategory(category);
              iMat.addExtra("currentCount", iMat.findProductsByCategory(category).length.toString());

          iMat.selectSelection(products);
        }
      },
      backgroundColor: isSelected
          ? const Color(0xFF7EAA3A)
          : const Color.fromARGB(0, 0, 0, 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 244, 244, 244),
        border: Border.all(
          color: const Color.fromARGB(255, 152, 195, 88),
          width: 3,
        ),
      ),
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kategorier",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCategoryButton(
                    context,
                    "Alla produkter",
                    Icons.store,
                    ProductCategory.UNDEFINED,
                  ),
                  _buildCategoryButton(
                    context,
                    "Kött",
                    Icons.restaurant_menu,
                    ProductCategory.MEAT,
                  ),
                  _buildCategoryButton(
                    context,
                    "Grönsaker",
                    Icons.eco,
                    ProductCategory.VEGETABLE_FRUIT,
                  ),
                  _buildCategoryButton(
                    context,
                    "Frukt",
                    Icons.apple,
                    ProductCategory.FRUIT,
                  ),
                  _buildCategoryButton(
                    context,
                    "Mejeri",
                    Icons.local_drink,
                    ProductCategory.DAIRIES,
                  ),
                  _buildCategoryButton(
                    context,
                    "Bröd",
                    Icons.bakery_dining,
                    ProductCategory.BREAD,
                  ),
                  _buildCategoryButton(
                    context,
                    "Dryck",
                    Icons.local_cafe,
                    ProductCategory.COLD_DRINKS,
                  ),
                  _buildCategoryButton(
                    context,
                    "Snacks",
                    Icons.fastfood,
                    ProductCategory.SWEET,
                  ),
                  _buildCategoryButton(
                    context,
                    "Bär",
                    Icons.apple,
                    ProductCategory.BERRY,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}