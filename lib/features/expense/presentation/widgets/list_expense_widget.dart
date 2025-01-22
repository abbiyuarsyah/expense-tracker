import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../core/shared_widget/card_container.dart';
import 'list_item_expense_widget.dart';

class ListExpenseWidget extends StatelessWidget {
  const ListExpenseWidget({super.key, required this.expenses});

  final List<ExpenseEntity> expenses;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.arrow_circle_left_outlined,
              ),
              Text("Today"),
              Icon(
                Icons.arrow_circle_right_outlined,
              )
            ],
          ),
          const SizedBox(
            height: Dimens.medium,
          ),
          const Divider(),
          const SizedBox(
            height: Dimens.medium,
          ),
          SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ListItemExpenseWidget(expense: expenses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
