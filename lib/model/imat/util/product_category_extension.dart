import 'package:imat_app/model/imat/product.dart';

extension ProductCategoryExtension on ProductCategory {
  String get displayName {
    switch(this) {
      case ProductCategory.POD:
        return "Baljväxter";
      case ProductCategory.BREAD:
        return "Bröd";
      case ProductCategory.BERRY:
        return "Bär";
      case ProductCategory.CITRUS_FRUIT:
        return "Citrus frukt";
      case ProductCategory.HOT_DRINKS:
        return "Varm dryck";
      case ProductCategory.COLD_DRINKS:
        return "Kall dryck";
      case ProductCategory.EXOTIC_FRUIT:
        return "Exotisk frukt";
      case ProductCategory.FISH:
        return "Fisk";
      case ProductCategory.VEGETABLE_FRUIT:
        return "Grönsaker & Frukt";
      case ProductCategory.CABBAGE:
        return "Kål";
      case ProductCategory.MEAT:
        return "Kött";
      case ProductCategory.DAIRIES:
        return "Mejeri";
      case ProductCategory.MELONS:
        return "Meloner";
      case ProductCategory.FLOUR_SUGAR_SALT:
        return "Mjöl, Socker & Salt";
      case ProductCategory.NUTS_AND_SEEDS:
        return "Nötter & Frön";
      case ProductCategory.PASTA:
        return "Pasta";
      case ProductCategory.POTATO_RICE:
        return"Potatis & Ris";
      case ProductCategory.ROOT_VEGETABLE:
        return"Rotfrukter";
      case ProductCategory.FRUIT:
        return"Frukt";
      case ProductCategory.SWEET:
        return"Godis";
      case ProductCategory.HERB:
        return"Örter";
      default:
        return "Övrigt";
    }
  } 
}