import 'dart:math';

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
            expenses: const [],
            addExpenseFlag: false,
            selectedDate: DateTime.now(),
            weeklySpent: 0,
          ),
        ) {
    on<GetExpensesEvent>(_onGetExpensesEvent);
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
      emit(state.copyWith(getExpensesStatus: StateStatus.failed));
    }, (r) {
      emit(state.copyWith(getExpensesStatus: StateStatus.loaded, expenses: r));
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
