import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/category_button.dart';
import 'package:imat_app/model/category_groups.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  ProductCategory selectedCategory = ProductCategory.UNDEFINED;
  String? expandedGroup;

  @override
  Widget build(BuildContext context) {
    final extras = context.watch<ImatDataHandler>().getExtras();
    final current = extras["currentCategory"];

    selectedCategory = _findCategoryByName(current);

    return Container(
      width: 300,
      height: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 244, 244, 244),
        border: Border.all(
          color: const Color.fromARGB(255, 152, 195, 88),
          width: 3,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sortiment",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildAllProductsButton(context),
                  const SizedBox(height: 10),

                  ...categoryGroups.map((group) {
                    final isExpanded = expandedGroup == group.name;

                    return Column(
                      children: [
                        _buildGroupButton(context, group, isExpanded),

                        if (isExpanded)
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              children: group.subcategories.map((cat) {
                                return _buildSubcategoryButton(context, cat);
                              }).toList(),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ProductCategory _findCategoryByName(String? name) {
    if (name == null) return ProductCategory.UNDEFINED;

    for (var group in categoryGroups) {
      for (var cat in group.subcategories) {
        if (categoryNames[cat] == name) return cat;
      }
    }
    return ProductCategory.UNDEFINED;
  }

  String? _findGroupForCategory(ProductCategory cat) {
    for (var group in categoryGroups) {
      if (group.subcategories.contains(cat)) return group.name;
    }
    return null;
  }

  Widget _buildAllProductsButton(BuildContext context) {
    final isSelected = selectedCategory == ProductCategory.UNDEFINED;

    return CategoryButton(
      label: "Alla produkter",
      icon: Icons.store,
      hoverColor: Colors.grey.shade200,
      isSelected: isSelected,
      isExpanded: false,
      backgroundColor: Colors.white,
      onTap: () {
        setState(() {
          selectedCategory = ProductCategory.UNDEFINED;
          expandedGroup = null;
        });

        final iMat = context.read<ImatDataHandler>();
        iMat.selectAllProducts();
        iMat.addExtra("currentCategory", "Alla produkter");
        iMat.addExtra("currentSubCategory", "Alla produkter");
        iMat.addExtra("currentCount", iMat.products.length.toString());
      },
    );
  }

  Widget _buildGroupButton(
      BuildContext context, CategoryGroup group, bool isExpanded) {
    return CategoryButton(
      label: group.name,
      icon: group.icon,
      hoverColor: Colors.grey.shade200,
      isSelected: false,
      isExpanded: isExpanded,
      backgroundColor: Colors.white,
      showArrow: true,
      onTap: () {
        setState(() {
          expandedGroup = isExpanded ? null : group.name;
        });
      },
    );
  }

  Widget _buildSubcategoryButton(BuildContext context, ProductCategory cat) {
    final isSelected = selectedCategory == cat;

    return CategoryButton(
      label: categoryNames[cat]!,
      icon: Icons.circle,
      hoverColor: Colors.grey.shade200,
      isSelected: isSelected,
      isExpanded: false,
      backgroundColor: Colors.white,
      onTap: () {
        setState(() {
          selectedCategory = cat;
          expandedGroup = _findGroupForCategory(cat);
        });

        final iMat = context.read<ImatDataHandler>();
        final label = categoryNames[cat]!;

        final products = iMat.findProductsByCategory(cat);
        iMat.selectSelection(products);

        iMat.addExtra("currentCategory", label);
        iMat.addExtra("currentSubCategory", label);
        iMat.addExtra("currentCount", products.length.toString());
      },
    );
  }
}