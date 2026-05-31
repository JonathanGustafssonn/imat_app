import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/pages/main_page_searched.dart';
import 'package:imat_app/widgets/filter_button.dart';
import 'package:imat_app/widgets/product_grid.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/header.dart';


class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  bool showMenu = false;

  bool priceLow = false;
  bool priceHigh = false;
  bool nameAZ = false;
  bool nameZA = false;

  bool showSaved = false;
  bool showLogin = false;

  @override
  Widget build(BuildContext context) {

    final iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Header(),
      ),



      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              width: double.infinity,
              height: 430,
              color: const Color(0xFFF7F7F7),

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),

                child: Row(
                  children: [

                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Bra priser alla dagar\ni veckan!",
                            style: TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),

                          const SizedBox(height: 40),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 197, 243, 129),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainPageSearched(),
                                ),
                                (route) => false,
                              );
                            },

                            icon: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.black,
                            ),

                            label: const Text(
                              "Handla",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      flex: 5,
                      child: Image.asset(
                        "assets/images/mainviewgreens.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 25),

              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Row(
                    children: const [

                      Icon(
                        Icons.local_shipping_outlined,
                        color: Color.fromARGB(255, 197, 243, 129),
                        size: 40,
                      ),

                      SizedBox(width: 12),

                      Text(
                        "100% fri frakt",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),

                  Row(
                    children: const [

                      Icon(
                        Icons.eco_outlined,
                        color: Color.fromARGB(255, 197, 243, 129),
                        size: 40,
                      ),

                      SizedBox(width: 12),

                      Text(
                        "Färska varor",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),

                  Row(
                    children: const [

                      Icon(
                        Icons.payments_outlined,
                        color: Color.fromARGB(255, 197, 243, 129),
                        size: 40,
                      ),

                      SizedBox(width: 12),

                      Text(
                        "Pensionär rabatt",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      FilterButton(
                        icon: Icons.filter_list,
                        label: 'Filtrera',
                        iconColor: Colors.black,
                        backgroundColor: const Color.fromARGB(255, 197, 243, 129),
                        onTap: () {
                          setState(() {
                            showMenu = !showMenu;
                          });
                        },
                      ),

                      const SizedBox(width: 15),

                      FilterButton(
                        icon: Icons.favorite,
                        label: 'Sparade varor',
                        iconColor: Colors.black,
                        backgroundColor: const Color.fromARGB(255, 197, 243, 129),
                        onTap: () {

                          setState(() {
                            showSaved = !showSaved;
                          });

                          if (showSaved) {
                            iMat.selectSelection(iMat.favorites);
                          } else {
                            iMat.selectAllProducts();
                          }
                        },
                      ),
                    ],
                  ),

                  if (showMenu)
                  const SizedBox(height: 15),

                  if (showMenu)
                  Container(
                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      children: [

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: priceLow,
                              onChanged: (v) {
                                setState(() {
                                  priceLow = v!;
                                  priceHigh = false;
                                  nameAZ = false;
                                  nameZA = false;
                                });

                                if (priceLow) {
                                  List<Product> list = [...iMat.selectProducts];
                                  list.sort((a, b) => a.price.compareTo(b.price));
                                  iMat.selectSelection(list);
                                } else {
                                  iMat.selectAllProducts();
                                }
                              },
                            ),
                            const Text("Pris: Låg till Hög"),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: priceHigh,
                              onChanged: (v) {
                                setState(() {
                                  priceHigh = v!;
                                  priceLow = false;
                                  nameAZ = false;
                                  nameZA = false;
                                });

                                if (priceHigh) {
                                  List<Product> list = [...iMat.selectProducts];
                                  list.sort((a, b) => b.price.compareTo(a.price));
                                  iMat.selectSelection(list);
                                } else {
                                  iMat.selectAllProducts();
                                }
                              },
                            ),
                            const Text("Pris: Hög till Låg"),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: nameAZ,
                              onChanged: (v) {
                                setState(() {
                                  nameAZ = v!;
                                  nameZA = false;
                                  priceLow = false;
                                  priceHigh = false;
                                });

                                if (nameAZ) {
                                  List<Product> list = [...iMat.selectProducts];
                                  list.sort((a, b) => a.name.compareTo(b.name));
                                  iMat.selectSelection(list);
                                } else {
                                  iMat.selectAllProducts();
                                }
                              },
                            ),
                            const Text("A -> Ö"),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: nameZA,
                              onChanged: (v) {
                                setState(() {
                                  nameZA = v!;
                                  nameAZ = false;
                                  priceLow = false;
                                  priceHigh = false;
                                });

                                if (nameZA) {
                                  List<Product> list = [...iMat.selectProducts];
                                  list.sort((a, b) => b.name.compareTo(a.name));
                                  iMat.selectSelection(list);
                                } else {
                                  iMat.selectAllProducts();
                                }
                              },
                            ),
                            const Text("Ö -> A"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),

              child: ProductGrid()
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}