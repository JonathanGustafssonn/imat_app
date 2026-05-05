import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class QuantitySelector extends StatelessWidget {
  final Product product;
  const QuantitySelector({super.key, required this.product});
  //TODO: cange to provider architecture, as to make the same data show on overview aswell as modal view


  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final quantity = iMat. getQuantity(product);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(167, 2, 196, 255)),
        color: const Color.fromARGB(255, 59, 167, 255),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: (){
            if(quantity > 0){
              iMat.shoppingCartUpdate(ShoppingItem(product, amount: quantity.toDouble()), delta: -1);
            }
          }, icon: const Icon(Icons.remove)),

          SizedBox(width: 24),

          Text('$quantity'),

          SizedBox(width: 24),

          IconButton(onPressed: (){
            iMat.shoppingCartAdd(ShoppingItem(product, amount: 1));
          }, icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
