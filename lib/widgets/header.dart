import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/profile_menu_popup.dart';
import 'package:imat_app/widgets/shopping_cart_popup.dart';
import 'package:imat_app/widgets/search_bar.dart';
import 'package:imat_app/widgets/login_popup.dart';
import 'package:imat_app/pages/main_view.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final extras = iMat.getExtras();

    final bool isLoggedIn = extras["isLoggedIn"] == true;

    final totalItems = iMat.getShoppingCart().items.fold(
      0,
      (sum, item) => sum + item.amount.toInt(),
    );

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 20,
      title: Row(
        children: [
          const SizedBox(width: 20),

          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap:() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainView(),
                ),
              );
            },
            child: Image.asset(
              "assets/images/iMat_logo.png",
              height: 100,
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
            child: const SearchBarHeader(),
          ),

          const Spacer(),

          TextButton.icon(
            onPressed: () async {
              if (!isLoggedIn) {
                await showDialog(
                  context: context,
                  barrierColor: Colors.black54,
                  builder: (_) => const LoginPopup(),
                );
              } else {
                await showDialog(
                  context: context,
                  barrierColor: Colors.black54,
                  builder: (_) => const ProfileMenuPopup(),
                );
              }
            },
            icon: const Icon(Icons.person_outline, color: Colors.black),
            label: Text(
              isLoggedIn ? "Konto" : "Logga in",
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),

          const SizedBox(width: 20),

          Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                onTap: () {
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
                    color: const Color.fromARGB(255, 197, 243, 129),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 80,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${iMat.shoppingCartTotal().toStringAsFixed(2)} kr",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (totalItems > 0)
                Positioned(
                  left: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          totalItems.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
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