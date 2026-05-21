import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/menu_popup.dart';
import 'package:imat_app/widgets/profile_menu_popup.dart';
import 'package:imat_app/widgets/shopping_cart_popup.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/search_bar.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();

    return AppBar(

      automaticallyImplyLeading: false,

      backgroundColor: Colors.white,
      elevation: 0,

      titleSpacing: 20,

      title: Row(
        children: [

          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
              size: 34,
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierColor: Colors.transparent,
                builder: (_) => const MenuPopup(
                  title: "Meny",
                  message: "Här kan du navigera i appen.",
                ),
              );
            },
          ),

          const SizedBox(width: 20),

          const Text.rich(
            TextSpan(
              children: [

                TextSpan(
                  text: "i",
                  style: TextStyle(
                    fontSize: 34,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                TextSpan(
                  text: "M",
                  style: TextStyle(
                    fontSize: 34,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                TextSpan(
                  text: "at",
                  style: TextStyle(
                    fontSize: 34,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          Container(
            width: 600,
            height: 48,

            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(30),
            ),
            child:
              SearchBarHeader(),
          ),

          const Spacer(),

          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                barrierColor: Colors.transparent,
                builder: (_) => const ProfileMenuPopup(),
              );
            },

            icon: const Icon(
              Icons.person_outline,
              color: Colors.black,
            ),

            label: const Text(
              "Logga in",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(width: 20),

          Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                onTap:() {
                  showDialog(
                    context: context,
                    barrierColor: Colors.transparent,
                    builder: (_) => const ShoppingCartPopup(
                      title: "Varukorg",
                      message: "Här kan du se dina varor",
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF97C64E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),

                      Text(
                        "${iMat.shoppingCartTotal().toStringAsFixed(2)} kr",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (iMat.getShoppingCart().items.isNotEmpty)
                Positioned(
                  left: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      iMat.getShoppingCart().items.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ],
      ),
     ],
    ),
    );
  }
}