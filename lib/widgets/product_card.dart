import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_modal.dart';
import 'package:imat_app/widgets/quantity_selector.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ImatDataHandler iMat;

  const ProductCard(this.product, this.iMat, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color.fromARGB(255, 212, 212, 212), width: 1)),
        child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => ProductModal(iMat: iMat, product: product),
        );
      },
      child:Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 180, child: iMat.getImage(product)),
              SizedBox(height: 12),
              Text(
                product.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${product.price.toStringAsFixed(2)} ${product.unit}',
                style: const TextStyle(fontSize: 18, color: Colors.green),
              ),
              Spacer(),
              QuantitySelector(product: product),
            ],
          ),
        ),
    ),);
  }
}




/**
 * 
 * InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => ProductModal(iMat: iMat, product: product),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 180, child: iMat.getImage(product)),
              SizedBox(height: 12),
              Text(
                product.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${product.price.toStringAsFixed(2)} ${product.unit}',
                style: const TextStyle(fontSize: 18, color: Colors.green),
              ),
              Spacer(),
              QuantitySelector(product: product),
            ],
          ),
        ),
      ),
    );
 */