import 'package:expense_tracker/features/expense/domain/use_case/add_expense.dart';
import 'package:expense_tracker/features/expense/domain/use_case/delete_expense.dart';
import 'package:expense_tracker/features/expense/domain/use_case/get_expenses.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_state.dart';
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
            stateStatus: StateStatus.init,
            expense: [],
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
    emit(state.copyWith(stateStatus: StateStatus.loading));

    final result = await getExpenses(null);
    result.fold((l) {
      emit(state.copyWith(stateStatus: StateStatus.failed));
    }, (r) {
      emit(state.copyWith(stateStatus: StateStatus.loaded, expense: r));
    });
  }

  Future<void> _onAddExpenseEvent(
    AddExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(stateStatus: StateStatus.loading));

    final result = await deleteExpense(event.expense);
    result.fold((l) {
      emit(state.copyWith(stateStatus: StateStatus.failed));
    }, (r) {
      emit(state.copyWith(stateStatus: StateStatus.loaded));
    });
  }

  Future<void> _onDeleteExpenseEvent(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(stateStatus: StateStatus.loading));

    final result = await deleteExpense(event.expense);
    result.fold((l) {
      emit(state.copyWith(stateStatus: StateStatus.failed));
    }, (r) {
      emit(state.copyWith(stateStatus: StateStatus.loaded));
    });
  }
}
