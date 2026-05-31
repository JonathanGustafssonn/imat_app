import 'package:flutter/material.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/header.dart';
import 'package:imat_app/widgets/product_grid.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/filter_menu.dart';
import 'package:imat_app/widgets/breadcrumbs.dart';
import 'package:imat_app/widgets/side_menu.dart';
import 'package:imat_app/widgets/filter_button.dart';

class MainPageSearched extends StatefulWidget {
  const MainPageSearched({super.key});

  @override
  State<MainPageSearched> createState() => _MainPageSearchedState();
}

class _MainPageSearchedState extends State<MainPageSearched> {
  bool showFilterMenu = false;

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
      body: Stack(
        children: [
          Row(
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
                      items: ["Hem", category, subCategory],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
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
                          Row(
                            children: [
                              FilterButton(
                                icon: Icons.filter_list,
                                label: "Filtrera",
                                iconColor: Colors.black,
                                backgroundColor:
                                    const Color.fromARGB(255, 197, 243, 129),
                                onTap: () {
                                  setState(() {
                                    showFilterMenu = !showFilterMenu;
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              FilterButton(
                                icon: Icons.favorite,
                                label: "Sparade varor",
                                iconColor: Colors.black,
                                backgroundColor:
                                    const Color.fromARGB(255, 197, 243, 129),
                                onTap: () {
                                  iMat.selectSelection(iMat.favorites);
                                  iMat.addExtra("currentCategory", "Sparade varor");
                                  iMat.addExtra("currentSubCategory", "Sparade varor");
                                  iMat.addExtra("currentCount",
                                      iMat.favorites.length.toString());
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: ProductGrid(axisCount: 4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showFilterMenu)
            Positioned(
              top: 150,
              right: 50,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(16),
                child: FilterMenu(),
              ),
            ),
        ],
      ),
    );
  }
}
