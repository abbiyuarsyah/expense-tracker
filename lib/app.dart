import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/enums/select_date_enum.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:expense_tracker/features/expense/presentation/pages/add_expense_page.dart';
import 'package:expense_tracker/features/expense/presentation/pages/expense_summary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/service_locator/service_locator.dart';
import 'features/expense/presentation/bloc/expense_event.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => sl<ExpenseBloc>()
        ..add(const GetExpensesEvent(selectDate: SelectDateEnum.today))
        ..add(const GetWeeklyExpenseEvet()),
      child: MaterialApp(
        title: tr('expense_tracker'),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const ExpenseSummaryPage(),
          '/add-expense': (context) => const AddExpensePage(),
        },
      ),
    );
  }
}
