import 'package:expense_tracker/core/enums/expense_category_enum.dart';
import 'package:expense_tracker/core/extensions/number_formatter.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/dimens.dart';

class ListItemExpenseWidget extends StatelessWidget {
  const ListItemExpenseWidget({super.key, required this.expense});

  final ExpenseEntity expense;

  @override
  Widget build(Object context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.xxLarge),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            child: Icon(
              Icons.food_bank,
              size: 40,
            ),
          ),
          const SizedBox(width: Dimens.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ExpenseCategoryEnum.values[expense.category].value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(expense.description),
              ],
            ),
          ),
          Text(
            expense.amount.toEuroFormat,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
