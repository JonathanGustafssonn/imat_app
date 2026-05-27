import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';

class CategoryGroup {
  final String name;
  final IconData icon;
  final List<ProductCategory> subcategories;

  CategoryGroup({
    required this.name,
    required this.icon,
    required this.subcategories,
  });
}

final Map<ProductCategory, String> categoryNames = {
  ProductCategory.FRUIT: "Frukt",
  ProductCategory.CITRUS_FRUIT: "Citrusfrukt",
  ProductCategory.EXOTIC_FRUIT: "Exotisk frukt",
  ProductCategory.MELONS: "Melon",
  ProductCategory.BERRY: "Bär",
  ProductCategory.VEGETABLE_FRUIT: "Grönsaker",
  ProductCategory.CABBAGE: "Kål",
  ProductCategory.ROOT_VEGETABLE: "Rotfrukter",
  ProductCategory.HERB: "Örter",

  ProductCategory.MEAT: "Kött",
  ProductCategory.FISH: "Fisk",

  ProductCategory.DAIRIES: "Mejeri",
  ProductCategory.BREAD: "Bröd",

  ProductCategory.FLOUR_SUGAR_SALT: "Skafferi",
  ProductCategory.NUTS_AND_SEEDS: "Nötter & Frön",
  ProductCategory.PASTA: "Pasta",
  ProductCategory.POTATO_RICE: "Potatis & Ris",

  ProductCategory.SWEET: "Snacks",

  ProductCategory.COLD_DRINKS: "Kalla drycker",
  ProductCategory.HOT_DRINKS: "Varma drycker",
};

final List<CategoryGroup> categoryGroups = [
  CategoryGroup(
    name: "Frukt & Grönt",
    icon: Icons.eco,
    subcategories: [
      ProductCategory.FRUIT,
      ProductCategory.CITRUS_FRUIT,
      ProductCategory.EXOTIC_FRUIT,
      ProductCategory.MELONS,
      ProductCategory.BERRY,
      ProductCategory.VEGETABLE_FRUIT,
      ProductCategory.CABBAGE,
      ProductCategory.ROOT_VEGETABLE,
      ProductCategory.HERB,
    ],
  ),
  CategoryGroup(
    name: "Kött & Fisk",
    icon: Icons.restaurant_menu,
    subcategories: [
      ProductCategory.MEAT,
      ProductCategory.FISH,
    ],
  ),
  CategoryGroup(
    name: "Mejeri",
    icon: Icons.local_drink,
    subcategories: [
      ProductCategory.DAIRIES,
    ],
  ),
  CategoryGroup(
    name: "Bröd",
    icon: Icons.bakery_dining,
    subcategories: [
      ProductCategory.BREAD,
    ],
  ),
  CategoryGroup(
    name: "Skafferi",
    icon: Icons.kitchen,
    subcategories: [
      ProductCategory.FLOUR_SUGAR_SALT,
      ProductCategory.NUTS_AND_SEEDS,
      ProductCategory.PASTA,
      ProductCategory.POTATO_RICE,
    ],
  ),
  CategoryGroup(
    name: "Snacks",
    icon: Icons.fastfood,
    subcategories: [
      ProductCategory.SWEET,
    ],
  ),
  CategoryGroup(
    name: "Dryck",
    icon: Icons.local_cafe,
    subcategories: [
      ProductCategory.COLD_DRINKS,
      ProductCategory.HOT_DRINKS,
    ],
  ),
];