import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/shopping_cart_popup.dart';
import 'package:provider/provider.dart';

class QuantitySelector extends StatelessWidget {
  final Product product;
  final double? width;
  final double? height;
  const QuantitySelector({
    super.key,
    required this.product,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final quantity = iMat.getQuantity(product);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48,
      child: quantity == 0
            ? _buildAddButton(iMat)
            : _buildQuantitySelector(iMat, quantity),
    );
  }

  Widget _buildAddButton(ImatDataHandler iMat) {
    return ElevatedButton(
      onPressed: () {
        iMat.shoppingCartAdd(ShoppingItem(product, amount: 1));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        "Lägg i varukorg",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildQuantitySelector(ImatDataHandler iMat, int quantity) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              iMat.shoppingCartUpdate(
                ShoppingItem(product, amount: quantity.toDouble()),
                delta: -1,
              );
            },
            icon: const Icon(Icons.remove, color: Colors.white),
          ),

          Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          IconButton(
            onPressed: () {
              iMat.shoppingCartAdd(ShoppingItem(product, amount: 1));
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}




/**
 * Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(167, 2, 196, 255)),
        color: const Color.fromARGB(255, 59, 183, 126),
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
            final bool cartWasEmpty = iMat.getShoppingCart().items.isEmpty;

            iMat.shoppingCartAdd(ShoppingItem(product, amount: 1));

            if (cartWasEmpty) {
              showDialog(
                context: context,
                barrierColor: Colors.transparent,
                builder: (_) => const ShoppingCartPopup(
                  title: "Varukorg",
                  message: "Här kan du se dina varor",
                ),
              );
            }
          }, icon: const Icon(Icons.add)),
        ],
      ),
    );
 */