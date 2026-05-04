import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/filter_button.dart';

class MainPageSearched extends StatelessWidget {
  const MainPageSearched({super.key});

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;

    // Det finns en version utan gridDelegate nedan.
    // Den kan vara enklare att förstå.
    // Denna version har fördelen att kort skapas on-demand.
    return Scaffold(
      appBar: AppBar(
        title: const Text('iMats produkter'),
        backgroundColor: const Color(0xFF34B5F0),
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF81D7FF),
            child: const Text(
              'Alla produkter',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 10),
            child: Row(
              children: [
                FilterButton(
                  icon: Icons.filter_list,
                  label: 'Filtrera',
                  iconColor: Colors.white,
                  backgroundColor: const Color(0xFF34B5F0),
                  onTap: () {},
                ),
                const SizedBox(width: 15),
                FilterButton(
                  icon: Icons.star,
                  label: 'Rea',
                  iconColor: Colors.yellow,
                  backgroundColor: const Color(0xFF34B5F0),
                  onTap: () {},
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                  border: Border.all(color: Colors.black),
                ),

                padding: const EdgeInsets.all(AppTheme.paddingSmall),
                child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: AppTheme.paddingSmall,
                    mainAxisSpacing: AppTheme.paddingSmall,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(product, iMat);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
