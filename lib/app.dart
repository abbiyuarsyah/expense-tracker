import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/features/expense/presentation/pages/expense_summary_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'expense',
      locale: context.locale,
      home: const ExpenseSummaryPage(),
    );
  }
}
