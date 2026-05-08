import 'package:flutter/material.dart';
import 'package:imat_app/pages/checkout1of3.dart';
import 'package:imat_app/pages/checkout3of3.dart';
import 'package:imat_app/pages/profile.dart';
import 'package:imat_app/widgets/icon_button.dart';

class CheckOut2Of3 extends StatelessWidget {
  const CheckOut2Of3({super.key});

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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: searchWidth.clamp(180, 500), 
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Sök...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),

            const SizedBox(width: 6),

            Container(
              height: 36,
              width: 42,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ],
        ),
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
          BuildIconButton(Icons.person, width: 90, height: 36, iconSize: 36, onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()),);},),
           BuildIconButton(Icons.shopping_cart, onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckOut1Of3()),);},),
        ],
      ),

      body: Column(
  children: [
    Container(
      width: double.infinity,
      color: const Color(0xFF81D7FF),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Steg 2 / 3"),
          const SizedBox(height: 6),
         Row(
           children: [
            Expanded(child: Container(height: 8, color: Colors.green,
              ),
                ),

            Expanded(child: Container(height: 8, color: Colors.yellow,
              ),
               ),

            Expanded(child: Container(height: 8,color: Colors.grey,
              ),
                ),
            ],
          ),
        ],
      ),
    ),

    Expanded(
      child: Stack(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 200,
                  height: 300,
                  color: Colors.grey[300],
                  child: const Center(child: Text("Dina varor")),
                ),
                Container(
                  width: 150,
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(child: Text("Lägg till?")),
                ),
              ],
            ),
          ),

          Positioned(
            left: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 40),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckOut1Of3(),),);
                },
              ),
            ),
          ),

          Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, size: 40),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckOut3Of3(),),);
                },
              ),
            ),
          ),
        ],
      ),
    ),
  ],
),
    );
  }
}