import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/filter_button.dart';

class FilterMenu extends StatefulWidget {
  const FilterMenu({super.key});

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  bool showMenu = false;
  bool showSaved = false;

  bool priceLow = false;
  bool priceHigh = false;
  bool nameAZ = false;
  bool nameZA = false;

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FilterButton(
              icon: Icons.filter_list,
              label: "Filtrera",
              iconColor: Colors.black,
              backgroundColor: const Color.fromARGB(255, 197, 243, 129),
              onTap: () {
                setState(() => showMenu = !showMenu);
              },
            ),

            const SizedBox(width: 15),

            FilterButton(
              icon: Icons.favorite,
              label: "Sparade varor",
              iconColor: Colors.black,
              backgroundColor: const Color.fromARGB(255, 197, 243, 129),
              onTap: () {
                setState(() => showSaved = !showSaved);

                if (showSaved) {
                  iMat.selectSelection(iMat.favorites);
                } else {
                  iMat.selectAllProducts();
                }
              },
            ),
          ],
        ),

        const SizedBox(height: 15),

        if (showMenu)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildCheckbox(
                  "Pris: Låg till Hög",
                  priceLow,
                  () {
                    setState(() {
                      priceLow = true;
                      priceHigh = false;
                      nameAZ = false;
                      nameZA = false;
                    });

                    final list = [...iMat.selectProducts]
                      ..sort((a, b) => a.price.compareTo(b.price));
                    iMat.selectSelection(list);
                  },
                ),

                _buildCheckbox(
                  "Pris: Hög till Låg",
                  priceHigh,
                  () {
                    setState(() {
                      priceHigh = true;
                      priceLow = false;
                      nameAZ = false;
                      nameZA = false;
                    });

                    final list = [...iMat.selectProducts]
                      ..sort((a, b) => b.price.compareTo(a.price));
                    iMat.selectSelection(list);
                  },
                ),

                _buildCheckbox(
                  "A → Ö",
                  nameAZ,
                  () {
                    setState(() {
                      nameAZ = true;
                      nameZA = false;
                      priceLow = false;
                      priceHigh = false;
                    });

                    final list = [...iMat.selectProducts]
                      ..sort((a, b) => a.name.compareTo(b.name));
                    iMat.selectSelection(list);
                  },
                ),

                _buildCheckbox(
                  "Ö → A",
                  nameZA,
                  () {
                    setState(() {
                      nameZA = true;
                      nameAZ = false;
                      priceLow = false;
                      priceHigh = false;
                    });

                    final list = [...iMat.selectProducts]
                      ..sort((a, b) => b.name.compareTo(a.name));
                    iMat.selectSelection(list);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, VoidCallback onSelect) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (_) => onSelect(),
        ),
        Text(label),
      ],
    );
  }
}
