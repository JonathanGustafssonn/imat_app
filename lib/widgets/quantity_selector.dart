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
            ? _buildAddButton(iMat,context)
            : _buildQuantitySelector(iMat, quantity),
    );
  }

  Widget _buildAddButton(ImatDataHandler iMat, context) {
    final bool cartWasEmpty = iMat.getShoppingCart().items.isEmpty;
    return ElevatedButton(
      onPressed: () {
        iMat.shoppingCartAdd(ShoppingItem(product, 1));

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
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        enabledMouseCursor: SystemMouseCursors.click, 
      ),
      child: const Text(
        "Lägg i varukorg",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildQuantitySelector(ImatDataHandler iMat, int quantity) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: Container(
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
                  ShoppingItem(product, quantity.toDouble()),
                  delta: -1,
                );
              },
              icon: const Icon(Icons.remove, color: Colors.white),
              mouseCursor: SystemMouseCursors.click,
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
                iMat.shoppingCartAdd(ShoppingItem(product, 1));
              },
              icon: const Icon(Icons.add, color: Colors.white),
              mouseCursor: SystemMouseCursors.click,
            ),
          ],
        ),
      ),
    );
  }
}
