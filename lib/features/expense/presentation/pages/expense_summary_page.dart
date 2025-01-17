import 'package:expense_tracker/core/constants/dimens.dart';
import 'package:flutter/material.dart';

import '../widgets/list_expense_widget.dart';
import '../widgets/summary_widget.dart';

class ExpenseSummaryPage extends StatelessWidget {
  const ExpenseSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expense",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimens.extraLarge),
            SummaryWidget(),
            SizedBox(height: Dimens.extraLarge),
            ListExpenseWidget(),
          ],
        ),
      ),
    );
  }
}
