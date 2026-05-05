import 'package:flutter/material.dart';

class BuildIconButton extends StatelessWidget {
  final IconData icon;
  final double width;
  final double height;
  final double iconSize;
  final VoidCallback? onPressed;

  const BuildIconButton(
    this.icon, {
    super.key,
    this.width = 36,
    this.height = 36,
    this.iconSize = 18,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          hoverColor: Colors.black.withValues(alpha: 0.08),
          splashColor: Colors.black.withValues(alpha: 0.1),
          onTap: onPressed,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color.fromARGB(223, 0, 0, 0)),
            ),
            child: Icon(
              icon,
              color: Colors.black,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
