import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      cursor: SystemMouseCursors.click,

      child: GestureDetector(
        onTap: widget.onTap,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          margin: const EdgeInsets.only(bottom: 12),

          decoration: BoxDecoration(
            color: hovering
                ? const Color(0xFFB0B0B0) // mörkare vid hover
                : const Color(0xFFC9C9C9), // originalfärg
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 3),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                  color: Colors.black,
                ),
              ),
              Icon(widget.icon, size: 26, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
