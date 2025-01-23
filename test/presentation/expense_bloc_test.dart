import 'package:expense_tracker/core/enums/state_status_enum.dart';
import 'package:expense_tracker/features/expense/domain/use_case/add_expense.dart';
import 'package:expense_tracker/features/expense/domain/use_case/delete_expense.dart';
import 'package:expense_tracker/features/expense/domain/use_case/get_expenses.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_state.dart';
import 'package:expense_tracker/features/expense/presentation/pages/add_expense_page.dart';
import 'package:expense_tracker/features/expense/presentation/pages/expense_summary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'expense_bloc_test.mocks.dart';

@GenerateMocks([AddExpense, DeleteExpense, GetExpenses, ExpenseBloc])
void main() {
  late AddExpense addExpense;
  late DeleteExpense deleteExpense;
  late GetExpenses getExpenses;
  late ExpenseBloc expenseBloc;
  late ExpenseState expenseState;

  setUp(() async {
    addExpense = MockAddExpense();
    deleteExpense = MockDeleteExpense();
    getExpenses = MockGetExpenses();
    expenseBloc = MockExpenseBloc();
    expenseState = ExpenseState(
      getExpensesStatus: StateStatus.init,
      addExpenseStatus: StateStatus.init,
      deleteExpenseStatus: StateStatus.init,
      weeklyExpenseStatus: StateStatus.init,
      expenses: const [],
      addExpenseFlag: false,
      selectedDate: DateTime.now(),
      weeklyExpensesByCategory: const {},
      totalExpenseInAWeek: 0,
      highestSpentCategory: -1,
    );
  });

  Widget createExpenseSummaryPageWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ExpenseBloc>(
        create: (_) => expenseBloc,
        child: const ExpenseSummaryPage(),
      ),
    );
  }

  Widget createAddExpensePageWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ExpenseBloc>(
        create: (_) => expenseBloc,
        child: const AddExpensePage(),
      ),
    );
  }

  group("widget test", () {
    testWidgets('displays loading indicator when getExpensesStatus is loading',
        (WidgetTester tester) async {
      when(expenseBloc.state).thenReturn(
        expenseState.copyWith(getExpensesStatus: StateStatus.loading),
      );
      when(expenseBloc.stream).thenAnswer(
        (_) => Stream.value(
          expenseState.copyWith(getExpensesStatus: StateStatus.loading),
        ),
      );

      await tester.pumpWidget(createExpenseSummaryPageWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
