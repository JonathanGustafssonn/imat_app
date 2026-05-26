import 'package:flutter/material.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/header.dart';
import 'package:imat_app/widgets/product_grid.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/filter_menu.dart';
import 'package:imat_app/widgets/breadcrumbs.dart';
import 'package:imat_app/widgets/side_menu.dart';

class MainPageSearched extends StatelessWidget {
  const MainPageSearched({super.key});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final extras = iMat.getExtras();

    final category = extras["currentCategory"] ?? "Kategori";
    final subCategory = extras["currentSubCategory"] ?? "";
    final count = extras["currentCount"] ?? "0";

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Header(),
      ),

      body: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: SideMenu(),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Breadcrumbs(
                  items: [
                    "Hem",
                    category,
                    subCategory,
                  ],
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subCategory,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "$count varor",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: FilterMenu(),
                ),

                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        border: Border.all(color: Colors.black),
                      ),
                      child: SingleChildScrollView(
                        child: const ProductGrid(axisCount: 4),
                      ),
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
