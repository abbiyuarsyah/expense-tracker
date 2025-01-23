import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/enums/expense_category_enum.dart';
import 'package:expense_tracker/core/enums/select_date_enum.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expense/domain/use_case/get_expenses.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_event.dart';
import 'package:expense_tracker/features/expense/presentation/pages/expense_summary_page.dart';
import 'package:expense_tracker/features/expense/presentation/widgets/list_expense_widget.dart';
import 'package:expense_tracker/features/expense/presentation/widgets/summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:expense_tracker/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

import '../test/presentation/expense_bloc_test.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late GetExpenses getExpenses;
  late ExpenseBloc expenseBloc;
  late Directory tempDir;

  setUp(() async {
    getExpenses = MockGetExpenses();
    expenseBloc = MockExpenseBloc();

    // Mock initial SharedPreferences values
    SharedPreferences.setMockInitialValues({});

    // Create a temporary directory for testing
    tempDir = Directory.systemTemp.createTempSync();

    // Mock the method channel for path_provider
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return tempDir.path;
        }
        return null;
      },
    );
  });

  tearDownAll(() async {
    // Clean up the temporary directory after tests
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }

    // Remove the mock handler
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      null,
    );
  });

  testWidgets('Check that expenses are loaded and a new expense can be added.',
      (WidgetTester tester) async {
    // Start the app
    app.main();
    await tester.pumpAndSettle();

    when(getExpenses(DateTime.now())).thenAnswer(
      (_) async => Right([
        ExpenseEntity(
          id: 1,
          amount: 20,
          category: ExpenseCategoryEnum.shopping.index,
          date: DateTime.now(),
          description: 'Test',
        )
      ]),
    );

    expenseBloc.add(const GetExpensesEvent(
      selectDate: SelectDateEnum.today,
    ));

    await tester.pumpAndSettle();
    expect(find.text('Expense Record'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(SummaryWidget), findsOneWidget);
    expect(find.byType(ListExpenseWidget), findsOneWidget);

    final addExpenseButton = find.text('Add a New Expense');
    expect(addExpenseButton, findsOneWidget);
    await tester.tap(addExpenseButton);
    await tester.pumpAndSettle();

    expect(find.text('Add a New Expense'), findsOneWidget);
    expect(
      find.byType(TextButton),
      findsWidgets,
    );

    // Fill in the amount field
    final amountField = find.byKey(const Key('amount_field'));
    expect(amountField, findsOneWidget);
    await tester.enterText(amountField, '50.00');
    await tester.pumpAndSettle();

    // Select a category
    final categoryDropdown = find.byKey(const Key('category_dropdown'));
    expect(categoryDropdown, findsOneWidget);
    await tester.tap(categoryDropdown);
    await tester.pumpAndSettle();

    // Choose a category from the dropdown menu
    final categoryOption = find.text(ExpenseCategoryEnum.food.value).last;
    expect(categoryOption, findsOneWidget);
    await tester.tap(categoryOption);
    await tester.pumpAndSettle();

    // Select a date
    final dateField = find.byKey(const Key('date_field'));
    expect(dateField, findsOneWidget);
    await tester.tap(dateField);
    await tester.pumpAndSettle();

    // Choose a date from the date picker
    await tester.tap(find.text('15'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Fill in the description
    final descriptionField = find.byKey(const Key('description_field'));
    expect(descriptionField, findsOneWidget);
    await tester.enterText(descriptionField, 'Lunch with friends');
    await tester.pumpAndSettle();

    // Submit the form
    final submitButton = find.byKey(const Key('submit_button'));
    expect(submitButton, findsOneWidget);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Verify the navigation is back to [ExpenseSummaryPage]
    final expenseSummaryPage = find.byType(ExpenseSummaryPage);
    expect(expenseSummaryPage, findsOneWidget);
  });
}
