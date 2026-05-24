import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color hoverColor;
  final Color backgroundColor;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.hoverColor,
    this.backgroundColor = Colors.transparent,
    required this.onTap,
    this.isSelected = false,
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
    if (widget.isSelected) {
      return const Color(0xFF7EAA3A);
    }
    if (hovering){
      return widget.hoverColor;
    }
    return const Color(0xFFC9C9C9);
  }
}