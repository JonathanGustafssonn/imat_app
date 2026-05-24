import 'package:flutter/material.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {

    var iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 300/450,
        ),
      itemCount: products.length, 
      itemBuilder: (context, index) {
        return ProductCard(products[index], iMat);
      },);
  }
}