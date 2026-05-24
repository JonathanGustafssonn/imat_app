import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/header.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/filter_button.dart';
import 'package:imat_app/widgets/side_menu.dart';

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: const Header(),
      ),
      body: Row(
  children: [
    const Padding(
      padding: EdgeInsets.only(top: 20),
      child: SideMenu(),
    ),

    Expanded(
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
            child: Row(
              children: [
                FilterButton(
                  icon: Icons.filter_list,
                  label: 'Filtrera',
                  iconColor: Colors.white,
                  backgroundColor:
                      const Color.fromARGB(255, 152, 195, 88),
                  onTap: () {},
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30),

              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  border: Border.all(color: Colors.black),
                ),

                padding:
                    const EdgeInsets.all(AppTheme.paddingSmall),

                child: GridView.builder(
                  itemCount: products.length,

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing:
                        AppTheme.paddingSmall,
                    mainAxisSpacing:
                        AppTheme.paddingSmall,
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
    ),
  ],
),
     
    );
  }
}
