import 'package:flutter/material.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/pages/main_page_searched.dart';
import 'package:imat_app/widgets/filter_button.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/header.dart';


class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {

    var iMat = context.watch<ImatDataHandler>();
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

            // HERO SECTION
            Container(
              width: double.infinity,
              height: 430,
              color: const Color(0xFFF7F7F7),

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),

                child: Row(
                  children: [

                    // LEFT TEXT
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

            // INFO SECTION
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

            // FILTERS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),

              child: Row(
                children: [

                  FilterButton(
                    icon: Icons.filter_list,
                    label: 'Filtrera',
                    iconColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 197, 243, 129),
                    onTap: () {},
                  ),

                  const SizedBox(width: 15),

                  FilterButton(
                    icon: Icons.star,
                    label: 'Rea',
                    iconColor: Colors.yellow,
                    backgroundColor: const Color.fromARGB(255, 197, 243, 129),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),

              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemCount: products.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.72,
                ),

                itemBuilder: (context, index) {

                  final product = products[index];

                  return ProductCard(product, iMat);
                },
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}