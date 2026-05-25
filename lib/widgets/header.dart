import 'package:flutter/material.dart';
import 'package:imat_app/widgets/profile_menu_popup.dart';
import 'package:imat_app/widgets/shopping_cart_popup.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/search_bar.dart';
import 'package:imat_app/widgets/login_popup.dart';
import 'package:imat_app/widgets/user_manager.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadLoginStatus();
  }

  Future<void> _loadLoginStatus() async {
    final user = await UserManager.loadLoggedInUser();
    setState(() {
      isLoggedIn = user != null;
    });
  }

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
          const SizedBox(width: 20),

          Image.asset("assets/images/iMat_logo.png", height: 100),

          const Spacer(),

          Container(
            width: 600,
            height: 48,

            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(30),
            ),
            child: SearchBarHeader(),
          ),

          const Spacer(),

          TextButton.icon(
            onPressed: () async {
              if (!isLoggedIn) {
                final result = await showGeneralDialog<bool>(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: "Login",
                  barrierColor: Colors.black54,
                  pageBuilder: (_, __, ___) => const LoginPopup(),
                );

                if (result == true) {
                  setState(() {
                    isLoggedIn = true; // 👈 DIREKT UPPDATERING
                  });
                  await _loadLoginStatus();
                }
              } else {
                final result = await showDialog<bool>(
                  context: context,
                  barrierColor: Colors.transparent,
                  builder: (_) => const ProfileMenuPopup(),
                );

                if (result == true) {
                  await _loadLoginStatus();
                }
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
                      horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 197, 243, 129),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_cart_outlined),
                      const SizedBox(width: 8),
                      Text(
                        "${iMat.shoppingCartTotal().toStringAsFixed(2)} kr",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
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