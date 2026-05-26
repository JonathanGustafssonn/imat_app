import 'package:flutter/material.dart';

class Breadcrumbs extends StatelessWidget {
  final List<String> items;

  const Breadcrumbs({super.key, required this.items});

  @override 
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 20),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Text(
              items[i],
              style: TextStyle(
                color: i == items.length -1 
                ? Colors.black
                : Colors.grey.shade700,
                fontWeight:
                i == items.length -1 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (i != items.length -1)
              const Text(' > '),
          ]
        ],
      ),
    );
  }
}