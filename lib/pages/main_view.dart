import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/pages/profile.dart';
import 'package:imat_app/widgets/icon_button.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;

    // Det finns en version utan gridDelegate nedan.
    // Den kan vara enklare att förstå.
    // Denna version har fördelen att kort skapas on-demand.
    return Scaffold(
      appBar: AppBar(
  backgroundColor: const Color(0xFF34B5F0),
  foregroundColor: Colors.white,
  title: LayoutBuilder(
  builder: (context, constraints) {
    final width = constraints.maxWidth;
    final searchWidth = width * 0.4; // 40% av appbar bredd

    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: searchWidth.clamp(180, 500), 
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Sök...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),

            const SizedBox(width: 6),

            Container(
              height: 36,
              width: 42,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "i", style: TextStyle(fontSize: 28, color: Colors.white)),
                  TextSpan(text: "M", style: TextStyle(fontSize: 28, color: Colors.red)),
                  TextSpan(text: "at", style: TextStyle(fontSize: 28, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  },
),
        actions: [
          BuildIconButton(Icons.person, width: 90, height: 36, iconSize: 36, onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()),);},),
          BuildIconButton(Icons.shopping_cart, onPressed:(){print("cart cart wart wart");}), 
        ],
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF81D7FF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BuildIconButton(Icons.checklist),
                BuildIconButton(Icons.store),
                BuildIconButton(Icons.favorite),
              ],
              ),
            ),

          Expanded(
            child: Padding(
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
        ],
      ),
    );
  }
}
