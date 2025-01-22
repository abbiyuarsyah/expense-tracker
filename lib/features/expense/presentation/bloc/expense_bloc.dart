import 'dart:math';

import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expense/domain/use_case/add_expense.dart';
import 'package:expense_tracker/features/expense/domain/use_case/delete_expense.dart';
import 'package:expense_tracker/features/expense/domain/use_case/get_expenses.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import 'expense_event.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc({
    required this.addExpense,
    required this.deleteExpense,
    required this.getExpenses,
  }) : super(
          const ExpenseState(
            getExpensesStatus: StateStatus.init,
            addExpenseStatus: StateStatus.init,
            expenses: [],
            addExpenseFlag: false,
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

    final result = await getExpenses(null);
    result.fold((l) {
      emit(state.copyWith(getExpensesStatus: StateStatus.failed));
    }, (r) {
      final result = r
          .where((element) => DateUtils.isSameDay(element.date, event.date))
          .toList();

      emit(state.copyWith(
        getExpensesStatus: StateStatus.loaded,
        expenses: result,
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
    emit(state.copyWith(addExpenseStatus: StateStatus.loading));

    final result = await deleteExpense(event.expense);
    result.fold((l) {
      emit(state.copyWith(addExpenseStatus: StateStatus.failed));
    }, (r) {
      emit(state.copyWith(addExpenseStatus: StateStatus.loaded));
    });
  }
}
