import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/quantity_selector.dart';

class ProductModal extends StatelessWidget {
  final Product product;
  final ImatDataHandler iMat;


  const ProductModal({super.key, required this.iMat, required this.product});

  @override
  Widget build(BuildContext context) {
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
                      padding: const EdgeInsets.only(top: 50, bottom: 16,left: 16,right: 16),
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
                                  Text(
                                    'BREADCRUMB TEMP',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),

                                  SizedBox(height: 8),

                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    product.category.name,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                        
                                  SizedBox(height: 16),
                      
                                  Text(
                                    '${product.price.toString()}\$',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                      
                                   SizedBox(height: 12),
                                        
                                  Text(
                                    'Description Title',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                        
                                  SizedBox(height: 4),
                      
                                  Text(
                                    'Description yada yada PLACEHOLDER',
                                    style: TextStyle(fontSize: 12),
                                  ),
                      
                                  SizedBox(height: 100,),
                      
                                  QuantitySelector(product: product),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/**
 
 */
