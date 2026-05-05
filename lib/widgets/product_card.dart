import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_modal.dart';
import 'package:imat_app/widgets/quantity_selector.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ImatDataHandler iMat;

  const ProductCard(this.product, this.iMat, {super.key});

  //TODO: Change build action to make the dimensions after what we actually want for our cards
  //TODO: Add functionallity for Modal and for add/ remove buttons on wares
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => ProductModal(iMat: iMat, product: product),
        );
      },
      child: (Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingSmall),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: iMat.getImage(product)),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.paddingSmall),
              Text(
                '${product.price.toStringAsFixed(2)} ${product.unit}',
                style: const TextStyle(fontSize: 14),
              ),
              QuantitySelector(product: product),
            ],
          ),
        ),
      )),
    );
  }
}
