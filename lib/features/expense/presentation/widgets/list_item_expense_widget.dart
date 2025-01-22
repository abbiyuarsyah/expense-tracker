import 'package:expense_tracker/core/enums/expense_category_enum.dart';
import 'package:expense_tracker/core/extensions/number_formatter.dart';
import 'package:expense_tracker/core/shared_widget/card_container.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/dimens.dart';

class ListItemExpenseWidget extends StatelessWidget {
  const ListItemExpenseWidget({super.key, required this.expense});

  final ExpenseEntity expense;

  @override
  Widget build(Object context) {
    return CardContainer(
      isTopRounded: true,
      isBottomRounded: true,
      color: Colors.blue.withOpacity(0.2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Icon(
              ExpenseCategoryEnum.values[expense.category].getCategoryIcon,
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
                    fontSize: 12,
                  ),
                ),
                Text(
                  expense.description.isEmpty ? '-' : expense.description,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
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
