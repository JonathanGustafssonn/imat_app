import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/quantity_selector.dart';
import 'package:provider/provider.dart';

class ProductModal extends StatelessWidget {
  final Product product;
  final ImatDataHandler iMat;

  const ProductModal({super.key, required this.iMat, required this.product});

  @override
  Widget build(BuildContext context) {
    // TODO: Make Scrollable
    //TODO: Add description buttons
    //TODO: split into differen classess,
    //TODO: fix the layout
    //TODO: Sync quantity selector with main page
    //TODO: make dynamic size of window and image
    //TODO: maybe change relationships beteween size somewhat
    return SingleChildScrollView(
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: AspectRatio(
            aspectRatio: 3/2,
            child: Material(
              borderRadius: BorderRadius.circular(12),
              elevation: 8,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: SizedBox(child: iMat.getImage(product)),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name, //TODO: ADD actual path here
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                    
                                  SizedBox(height: 12),
                    
                                  Text(
                                    'Description',
                                    style: TextStyle(fontSize: 16),
                                  ),
                    
                                  SizedBox(height: 20),
                    
                                  Center(child: QuantitySelector(product: product)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 255, 0, 0),
                            width: 200,
                            height: 10,
                          ),
                          Container(
                            color: const Color.fromARGB(255, 0, 255, 0),
                            width: 200,
                            height: 10,
                          ),
                          Container(
                            color: const Color.fromARGB(255, 248, 6, 228),
                            width: 200,
                            height: 10,
                          ),
                        ],
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
      ),
    );
  }
}