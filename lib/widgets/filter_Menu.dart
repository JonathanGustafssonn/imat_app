import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class FilterMenu extends StatefulWidget {
  const FilterMenu({super.key});

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  bool priceLow = false;
  bool priceHigh = false;
  bool nameAZ = false;
  bool nameZA = false;

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();

    return Container(
      width: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Filtrera",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          _buildCheckbox("Pris: Låg till Hög", priceLow, () {
            setState(() {
              priceLow = true;
              priceHigh = false;
              nameAZ = false;
              nameZA = false;
            });

            final list = [...iMat.selectProducts]
              ..sort((a, b) => a.price.compareTo(b.price));
            iMat.selectSelection(list);
          }),

          _buildCheckbox("Pris: Hög till Låg", priceHigh, () {
            setState(() {
              priceHigh = true;
              priceLow = false;
              nameAZ = false;
              nameZA = false;
            });

            final list = [...iMat.selectProducts]
              ..sort((a, b) => b.price.compareTo(a.price));
            iMat.selectSelection(list);
          }),

          _buildCheckbox("A → Ö", nameAZ, () {
            setState(() {
              nameAZ = true;
              nameZA = false;
              priceLow = false;
              priceHigh = false;
            });

            final list = [...iMat.selectProducts]
              ..sort((a, b) => a.name.compareTo(b.name));
            iMat.selectSelection(list);
          }),

          _buildCheckbox("Ö → A", nameZA, () {
            setState(() {
              nameZA = true;
              nameAZ = false;
              priceLow = false;
              priceHigh = false;
            });

            final list = [...iMat.selectProducts]
              ..sort((a, b) => b.name.compareTo(a.name));
            iMat.selectSelection(list);
          }),
        ],
      ),
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
