import 'package:flutter/material.dart';

enum ExpenseCategoryEnum {
  food('Food'),
  travel('Travel'),
  shopping('Shopping'),
  entertainment('Entertainment'),
  transportation('Transportaion');

  const ExpenseCategoryEnum(this.value);

  final String value;

  IconData get getCategoryIcon {
    switch (this) {
      case food:
        return Icons.food_bank_outlined;
      case travel:
        return Icons.travel_explore_outlined;
      case shopping:
        return Icons.shop_outlined;
      case entertainment:
        return Icons.music_note_outlined;
      case transportation:
        return Icons.emoji_transportation_outlined;
    }
  }
}
