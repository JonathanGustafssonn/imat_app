import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class FilterButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  bool showMenu = false;
  bool showSaved = false;

  @override
  Widget build(BuildContext context) {
    final iMat = context.read<ImatDataHandler>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Knapp
        Material(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {

              // Filtrera-knappen
              if (widget.label == "Filtrera") {
                setState(() {
                  showMenu = !showMenu;
                });
              }

              // Sparade varor-knappen
              if (widget.label == "Sparade varor") {
                setState(() {
                  showSaved = !showSaved;
                });

                if (showSaved) {
                  iMat.selectSelection(iMat.favorites);
                } else {
                  iMat.selectAllProducts();
                }
              }

              widget.onTap();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    size: 20,
                    color: widget.iconColor,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}