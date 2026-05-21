import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color hoverColor;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.hoverColor,
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
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 18,
          ),
          margin: const EdgeInsets.only(bottom: 12),

          decoration: BoxDecoration(
            color: _getColor(),
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

  Color _getColor() {
    if (hovering) {
      return widget.hoverColor;
    }

    return const Color(0xFFC9C9C9);
  }
}