import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/category_groups.dart';

class SearchBarHeader extends StatefulWidget {
  const SearchBarHeader({super.key});

  @override
  State<SearchBarHeader> createState() => _SearchBarHeaderState();
}

class _SearchBarHeaderState extends State<SearchBarHeader> {
  final TextEditingController _controller = TextEditingController();

  int _levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final matrix = List.generate(
      a.length + 1,
      (_) => List<int>.filled(b.length + 1, 0),
    );

    for (int i = 0; i <= a.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= b.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= a.length; i++) {
      for (int j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[a.length][b.length];
  }

  int _fuzzyScore(String query, String name) {
    query = query.toLowerCase();
    name = name.toLowerCase();

    if (name == query) return 100;
    if (name.startsWith(query)) return 90;
    if (name.contains(query)) return 80;

    final d = _levenshtein(query, name);
    return 60 - d * 10;
  }

  void _runSearch(BuildContext context) {
    final iMat = context.read<ImatDataHandler>();
    final query = _controller.text.trim().toLowerCase();

    if (query.isEmpty) {
      iMat.selectAllProducts();
      iMat.addExtra("currentCategory", "Alla produkter");
      iMat.addExtra("currentSubCategory", "Alla produkter");
      iMat.addExtra("currentCount", iMat.products.length.toString());
      return;
    }

    final catMatch = categoryNames.entries
        .map((e) => MapEntry(e.key, _fuzzyScore(query, e.value)))
        .where((e) => e.value > 50)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (catMatch.isNotEmpty) {
      final bestCat = catMatch.first.key;
      final label = categoryNames[bestCat]!;

      final products =
          iMat.products.where((p) => p.category == bestCat).toList();

      iMat.selectSelection(products);
      iMat.addExtra("currentCategory", label);
      iMat.addExtra("currentSubCategory", label);
      iMat.addExtra("currentCount", products.length.toString());
      return;
    }

    final scored = iMat.products
        .map((p) => MapEntry(p, _fuzzyScore(query, p.name)))
        .where((e) => e.value > 40)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final products = scored.map((e) => e.key).toList();

    iMat.selectSelection(products);
    iMat.addExtra("currentCategory", "Sökresultat");
    iMat.addExtra("currentSubCategory", query);
    iMat.addExtra("currentCount", products.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onSubmitted: (_) => _runSearch(context),
      decoration: InputDecoration(
        hintText: "Sök efter varor ...",
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _runSearch(context),
        ),
      ),
    );
  }
}