import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isExpanded;
  final Color backgroundColor;
  final Color hoverColor;
  final VoidCallback onTap;
  final bool showArrow;

  const CategoryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.backgroundColor,
    required this.hoverColor,
    required this.onTap,
    this.showArrow = false,
    this.isExpanded = false,
  });

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.isSelected || widget.isExpanded;

    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      onEnter: (_) {
        if (!mounted) return;
        setState(() => hovering = true);
      },
      onExit: (_) {
        if (!mounted) return;
        setState(() => hovering = false);
      },
      cursor: SystemMouseCursors.click,

      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onTap,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          margin: const EdgeInsets.symmetric(vertical: 4),

          decoration: BoxDecoration(
            color: active
                ? const Color.fromARGB(255, 197, 243, 129)
                : (hovering ? widget.hoverColor : widget.backgroundColor),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: active
                  ? const Color.fromARGB(255, 152, 195, 88)
                  : Colors.grey.shade300,
              width: 2,
            ),
          ),

          child: Row(
            children: [
              Icon(widget.icon, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              if (widget.showArrow)
                Icon(
                  widget.isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}