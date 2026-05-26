import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class SearchBarHeader extends StatefulWidget {
  const SearchBarHeader({super.key});

  @override
  State<SearchBarHeader> createState() => _SearchBarHeader();
}
class _SearchBarHeader extends State<SearchBarHeader> {
  final TextEditingController _controller = TextEditingController();

  void _runSearch(BuildContext context) {
    final iMat = context.read<ImatDataHandler>();
    final query = _controller.text.toLowerCase();

     final results = iMat.products.where((product) => product.name
    .toLowerCase().contains(query)).toList();
    
    iMat.addExtra('currentCategory', 'Sökresultat');
    iMat.addExtra('currentSubCategory', query);
    iMat.addExtra('currentCount', results.length.toString());

    if (results.isEmpty) {
      final random = List<Product>.from(iMat.products)..shuffle();

      iMat.selectSelection(
        random.take(5).toList());

      iMat.addExtra('currentCount', '5');
    } else {
      iMat.selectSelection(results);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,

      onSubmitted: (_) => _runSearch(context),

      decoration: InputDecoration(
        hintText: "Sök efter varor ...",

        border: InputBorder.none,

        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () => _runSearch(context),
        ),
      ),
    );
  }
}