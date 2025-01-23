import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/enums/expense_category_enum.dart';
import 'package:expense_tracker/core/enums/select_date_enum.dart';
import 'package:expense_tracker/core/enums/state_status_enum.dart';
import 'package:expense_tracker/core/shared_widget/error_screen_widget.dart';
import 'package:expense_tracker/core/utils/execptions.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expense/domain/use_case/add_expense.dart';
import 'package:expense_tracker/features/expense/domain/use_case/delete_expense.dart';
import 'package:expense_tracker/features/expense/domain/use_case/get_expenses.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_event.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_state.dart';
import 'package:expense_tracker/features/expense/presentation/pages/expense_summary_page.dart';
import 'package:expense_tracker/features/expense/presentation/widgets/list_item_expense_widget.dart';
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
      errorMessage: '',
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

    testWidgets('displays error screen when state is failed',
        (WidgetTester tester) async {
      final errorMessage = tr('unexpected_error');

      when(expenseBloc.state).thenReturn(
        expenseState.copyWith(
          getExpensesStatus: StateStatus.failed,
          errorMessage: errorMessage,
        ),
      );
      when(expenseBloc.stream).thenAnswer(
        (_) => Stream.value(
          expenseState.copyWith(
            getExpensesStatus: StateStatus.failed,
            errorMessage: errorMessage,
          ),
        ),
      );

      await tester.pumpWidget(createExpenseSummaryPageWidgetUnderTest());

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byType(ErrorScreenWidget), findsOneWidget);
    });

    testWidgets('displays expenses when state is loaded',
        (WidgetTester tester) async {
      when(expenseBloc.state).thenReturn(
        expenseState.copyWith(
          getExpensesStatus: StateStatus.loaded,
          expenses: [
            ExpenseEntity(
              id: 1,
              amount: 20,
              category: ExpenseCategoryEnum.food.index,
              date: DateTime.now(),
              description: 'Test',
            ),
          ],
        ),
      );
      when(expenseBloc.stream).thenAnswer(
        (_) => Stream.value(
          expenseState.copyWith(
            getExpensesStatus: StateStatus.loaded,
            expenses: [
              ExpenseEntity(
                id: 1,
                amount: 20,
                category: ExpenseCategoryEnum.food.index,
                date: DateTime.now(),
                description: 'Test',
              ),
            ],
          ),
        ),
      );

      await tester.pumpWidget(createExpenseSummaryPageWidgetUnderTest());

      expect(find.byType(ListItemExpenseWidget), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });
  });

  group("unit test and use case test", () {
    test(
      'getProducts should emit [loading, failed] when data fetching fails',
      () async* {
        when(getExpenses(DateTime.now())).thenAnswer(
          (_) async => Left(UnexpectedFailure()),
        );

        final expected = [
          expenseState.copyWith(getExpensesStatus: StateStatus.init),
          expenseState.copyWith(getExpensesStatus: StateStatus.loading),
          expenseState.copyWith(getExpensesStatus: StateStatus.failed),
        ];
        expectLater(expenseBloc, emitsInOrder(expected));
        expenseBloc.add(const GetExpensesEvent(
          selectDate: SelectDateEnum.today,
        ));
      },
    );

    test(
      'getExpenses should emit [Loading, loaded] when data is fetched successfully',
      () async* {
        when(getExpenses(DateTime.now())).thenAnswer(
          (_) async => const Right([]),
        );

        final expected = [
          expenseState.copyWith(getExpensesStatus: StateStatus.init),
          expenseState.copyWith(getExpensesStatus: StateStatus.loading),
          expenseState.copyWith(getExpensesStatus: StateStatus.loaded),
        ];
        expectLater(expenseBloc, emitsInOrder(expected));
        expenseBloc.add(const GetExpensesEvent(
          selectDate: SelectDateEnum.today,
        ));
      },
    );

    test(
      'addExpense should emit [loading, failed] when data triggering fails',
      () async* {
        when(addExpense(ExpenseEntity(
          id: 1,
          amount: 20,
          category: ExpenseCategoryEnum.shopping.index,
          date: DateTime.now(),
          description: 'Test',
        ))).thenAnswer(
          (_) async => Left(UnexpectedFailure()),
        );

        final expected = [
          expenseState.copyWith(addExpenseStatus: StateStatus.init),
          expenseState.copyWith(addExpenseStatus: StateStatus.loading),
          expenseState.copyWith(addExpenseStatus: StateStatus.failed),
        ];
        expectLater(expenseBloc, emitsInOrder(expected));
        expenseBloc.add(AddExpenseEvent(
          amount: 20,
          category: ExpenseCategoryEnum.shopping.index,
          dateTime: DateTime.now(),
          description: 'Test',
        ));
      },
    );

    test(
      'addExpense should emit [Loading, loaded] when data is triggered successfully',
      () async* {
        when(addExpense(ExpenseEntity(
          id: 1,
          amount: 20,
          category: ExpenseCategoryEnum.shopping.index,
          date: DateTime.now(),
          description: 'Test',
        ))).thenAnswer(
          (_) async => Right(ExpenseEntity(
            id: 1,
            amount: 20,
            category: ExpenseCategoryEnum.shopping.index,
            date: DateTime.now(),
            description: 'Test',
          )),
        );

        final expected = [
          expenseState.copyWith(addExpenseStatus: StateStatus.init),
          expenseState.copyWith(addExpenseStatus: StateStatus.loading),
          expenseState.copyWith(addExpenseStatus: StateStatus.loaded),
        ];
        expectLater(expenseBloc, emitsInOrder(expected));
        expenseBloc.add(AddExpenseEvent(
          amount: 20,
          category: ExpenseCategoryEnum.shopping.index,
          dateTime: DateTime.now(),
          description: 'Test',
        ));
      },
    );

    test(
      'deletExpense should emit [loading, failed] when data triggering fails',
      () async* {
        when(deleteExpense(ExpenseEntity(
          id: 1,
          amount: 20,
          category: ExpenseCategoryEnum.shopping.index,
          date: DateTime.now(),
          description: 'Test',
        ))).thenAnswer(
          (_) async => Left(UnexpectedFailure()),
        );

        final expected = [
          expenseState.copyWith(addExpenseStatus: StateStatus.init),
          expenseState.copyWith(addExpenseStatus: StateStatus.loading),
          expenseState.copyWith(addExpenseStatus: StateStatus.failed),
        ];
        expectLater(expenseBloc, emitsInOrder(expected));
        expenseBloc.add(DeleteExpenseEvent(
          expense: ExpenseEntity(
            id: 1,
            amount: 20,
            category: ExpenseCategoryEnum.shopping.index,
            date: DateTime.now(),
            description: 'Test',
          ),
        ));
      },
    );

    test(
      'deletExpense should emit [loading, failed] when data triggering fails',
      () async* {
        when(deleteExpense(ExpenseEntity(
          id: 1,
          amount: 20,
          category: ExpenseCategoryEnum.shopping.index,
          date: DateTime.now(),
          description: 'Test',
        ))).thenAnswer(
          (_) async => const Right(true),
        );

        final expected = [
          expenseState.copyWith(addExpenseStatus: StateStatus.init),
          expenseState.copyWith(addExpenseStatus: StateStatus.loading),
          expenseState.copyWith(addExpenseStatus: StateStatus.loaded),
        ];
        expectLater(expenseBloc, emitsInOrder(expected));
        expenseBloc.add(DeleteExpenseEvent(
          expense: ExpenseEntity(
            id: 1,
            amount: 20,
            category: ExpenseCategoryEnum.shopping.index,
            date: DateTime.now(),
            description: 'Test',
          ),
        ));
      },
    );
  });
}
