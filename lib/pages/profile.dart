import 'package:flutter/material.dart';
import 'package:imat_app/widgets/profile_button.dart';
import 'package:imat_app/pages/main_view.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iMat'),
        backgroundColor: const Color(0xFF34B5F0),
        foregroundColor: Colors.white,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF81D7FF),
            child: const SizedBox.shrink(),
          ),

          // Tillbaka-pil under subheadern
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 32),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainView()),);},),
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
