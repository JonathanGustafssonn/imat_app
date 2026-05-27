import 'package:flutter/material.dart';

class ProfileButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      opaque: false,
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
          curve: Curves.easeOut,

          width: 350,
          height: 55,

          decoration: BoxDecoration(
            color: hovering
                ? const Color(0xFFB5B5B5)
                : const Color(0xFFC9C9C9),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black, width: 4),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Icon(
                  widget.icon,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
