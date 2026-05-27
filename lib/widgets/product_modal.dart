import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/breadcrumbs.dart';
import 'package:imat_app/widgets/quantity_selector.dart';
import 'package:provider/provider.dart';

class ProductModal extends StatelessWidget {
  final Product product;
  

  const ProductModal({super.key,  required this.product});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final extras = iMat.getExtras();
    final category = extras["currentCategory"] ?? "Kategori";
    final subCategory = extras["currentSubCategory"] ?? "";

    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: AspectRatio(
          aspectRatio: 1.6,
          child: Material(
            borderRadius: BorderRadius.circular(12),
            elevation: 8,
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 70,
                        bottom: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: SizedBox(child: iMat.getImage(product)),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Breadcrumbs(items: [
                                    "Hem",
                                    category ?? "Kategori",
                                    subCategory ?? "",
                                    product.name
                                  ]),
                                  SizedBox(height: 8),
          
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                      
                                  Text(
                                    subCategory,
                                    style: TextStyle(fontSize: 15),
                                  ),
                      
                                  SizedBox(height: 16),
                      
                                  Text(
                                    '${product.price.toStringAsFixed(2)} ${product.unit}',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                      
                                  SizedBox(height: 12),
                      
                                  Text(
                                    'Produkt info',
                                    style: TextStyle(fontSize: 16),
                                  ),
                      
                                  SizedBox(height: 4),
                      
                                  Text(
                                    'Placeholder för beskrvining',
                                    style: TextStyle(fontSize: 12),
                                  ),
                      
                                  SizedBox(height: 100),

                                  QuantitySelector(
                                    product: product,
                                    width: 250,
                                    height: 80,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 8,
                  child: IconButton(
                    mouseCursor: SystemMouseCursors.click,
                    onPressed: () {
                      iMat.toggleFavorite(product);
                    },
                    icon: Icon(
                      size: 64,
                      iMat.isFavorite(product)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          iMat.isFavorite(product)
                              ? Colors.green
                              : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
