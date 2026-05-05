import 'package:flutter/material.dart';
import 'package:imat_app/widgets/profile_button.dart';
import 'package:imat_app/widgets/icon_button.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF34B5F0),
        foregroundColor: Colors.white,
        title: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final searchWidth = width * 0.4; // 40% av appbar bredd

            return Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "i", style: TextStyle(fontSize: 28, color: Colors.white)),
                          TextSpan(text: "M", style: TextStyle(fontSize: 28, color: Colors.red)),
                          TextSpan(text: "at", style: TextStyle(fontSize: 28, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          BuildIconButton(
            Icons.shopping_cart,
            onPressed: () {
              print("cart cart wart wart");
            },
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF81D7FF),
          ),

          const SizedBox(height: 10),

          // Profilikon
          Center(
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Ben Dover",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Rutan som innehåller knapparna
          Center(
            child: Container(
              width: 375,
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black, width: 5),
              ),

              child: Column(
                children: [
                  ProfileButton(
                    label: "Inställningar",
                    icon: Icons.settings,
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  ProfileButton(
                    label: "Gillade Varor",
                    icon: Icons.favorite,
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  ProfileButton(
                    label: "Inköpslistor",
                    icon: Icons.list_alt,
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  ProfileButton(
                    label: "Kvitton",
                    icon: Icons.receipt_long,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
