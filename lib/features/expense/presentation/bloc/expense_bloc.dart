import 'dart:math';

import 'package:expense_tracker/core/enums/expense_category_enum.dart';
import 'package:expense_tracker/core/enums/select_date_enum.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expense/domain/use_case/add_expense.dart';
import 'package:expense_tracker/features/expense/domain/use_case/delete_expense.dart';
import 'package:expense_tracker/features/expense/domain/use_case/get_expenses.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status_enum.dart';
import 'expense_event.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc({
    required this.addExpense,
    required this.deleteExpense,
    required this.getExpenses,
  }) : super(
          ExpenseState(
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
          ),
        ) {
    on<GetExpensesEvent>(_onGetExpensesEvent);
    on<GetWeeklyExpenseEvet>(_onGetWeeklyExpensesEvent);
    on<AddExpenseEvent>(_onAddExpenseEvent);
    on<DeleteExpenseEvent>(_onDeleteExpenseEvent);
  }

  final AddExpense addExpense;
  final DeleteExpense deleteExpense;
  final GetExpenses getExpenses;

  Future<void> _onGetExpensesEvent(
    GetExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(getExpensesStatus: StateStatus.loading));

    late DateTime date;
    switch (event.selectDate) {
      case SelectDateEnum.today:
        date = DateTime.now();
      case SelectDateEnum.yesterday:
        date = state.selectedDate.subtract(const Duration(days: 1));
      case SelectDateEnum.tomorrow:
        date = state.selectedDate.add(const Duration(days: 1));
      case SelectDateEnum.currentDate:
        date = state.selectedDate;
      default:
    }

    emit(state.copyWith(selectedDate: date));

    final result = await getExpenses(date);
    result.fold((l) {
      emit(state.copyWith(
        getExpensesStatus: StateStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(getExpensesStatus: StateStatus.loaded, expenses: r));
    });
  }

  Future<void> _onGetWeeklyExpensesEvent(
    GetWeeklyExpenseEvet event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(weeklyExpenseStatus: StateStatus.loading));

    final result = await getExpenses(null);
    result.fold((l) {
      emit(state.copyWith(weeklyExpenseStatus: StateStatus.failed));
    }, (r) {
      final today = DateTime.now();
      final oneWeekAgo = today.subtract(const Duration(days: 7));
      final filteredExpenses = r
          .where((expense) =>
              (expense.date.isAfter(oneWeekAgo) ||
                  expense.date.isAtSameMomentAs(oneWeekAgo)) &&
              expense.date.isBefore(today.add(const Duration(days: 1))))
          .toList();
      final Map<ExpenseCategoryEnum, double> categoryTotals = {};
      for (var expense in filteredExpenses) {
        categoryTotals[ExpenseCategoryEnum.values[expense.category]] =
            (categoryTotals[ExpenseCategoryEnum.values[expense.category]] ??
                    0) +
                expense.amount;
      }
      ExpenseCategoryEnum? highestSpendingCategory;
      double highestSpendingAmount = 0.0;

      categoryTotals.forEach((category, total) {
        if (total > highestSpendingAmount) {
          highestSpendingCategory = category;
          highestSpendingAmount = total;
        }
      });

      final totalExpenseInAWeek = r
          .where((expense) =>
              expense.date
                  .isAfter(oneWeekAgo.subtract(const Duration(days: 1))) &&
              expense.date.isBefore(today.add(const Duration(days: 1))))
          .fold(0.0, (sum, expense) => sum + expense.amount);

      emit(state.copyWith(
        weeklyExpenseStatus: StateStatus.loaded,
        weeklyExpensesByCategory: categoryTotals,
        totalExpenseInAWeek: totalExpenseInAWeek,
        highestSpentCategory: highestSpendingCategory?.index,
      ));
    });
  }

  Future<void> _onAddExpenseEvent(
    AddExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(addExpenseStatus: StateStatus.loading));

    final result = await addExpense(ExpenseEntity(
      id: Random().nextInt(100),
      amount: event.amount,
      category: event.category,
      date: event.dateTime,
      description: event.description,
    ));

    result.fold((l) {
      emit(state.copyWith(
        addExpenseStatus: StateStatus.failed,
        addExpenseFlag: !state.addExpenseFlag,
      ));
    }, (r) {
      emit(state.copyWith(
        addExpenseStatus: StateStatus.loaded,
        addExpenseFlag: !state.addExpenseFlag,
      ));
    });
  }

  Future<void> _onDeleteExpenseEvent(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(deleteExpenseStatus: StateStatus.loading));

    final result = await deleteExpense(event.expense);
    result.fold((l) {
      emit(state.copyWith(deleteExpenseStatus: StateStatus.failed));
    }, (r) {
      emit(state.copyWith(deleteExpenseStatus: StateStatus.loaded));
    });
  }
}
