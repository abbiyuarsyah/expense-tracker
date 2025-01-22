import 'package:expense_tracker/core/constants/dimens.dart';
import 'package:expense_tracker/features/expense/presentation/pages/add_expense_page.dart';
import 'package:flutter/material.dart';

import '../../../../core/shared_widget/card_container.dart';
import '../widgets/list_expense_widget.dart';
import '../widgets/summary_widget.dart';

class ExpenseSummaryPage extends StatelessWidget {
  const ExpenseSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          "Expense",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Dimens.extraLarge),
                SummaryWidget(),
                SizedBox(height: Dimens.extraLarge),
                ListExpenseWidget(),
              ],
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CardContainer(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: Dimens.xxLarge),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddExpensePage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dimens.medium),
                          ),
                        ),
                        child: Text(
                          'Add Expense',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
