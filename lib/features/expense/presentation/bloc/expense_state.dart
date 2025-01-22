import 'package:equatable/equatable.dart';
import 'package:expense_tracker/core/enums/state_status.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';

class ExpenseState extends Equatable {
  const ExpenseState({required this.expense, required this.stateStatus});

  final List<ExpenseEntity> expense;
  final StateStatus stateStatus;

  ExpenseState copyWith({
    List<ExpenseEntity>? expense,
    StateStatus? stateStatus,
  }) {
    return ExpenseState(
      expense: expense ?? this.expense,
      stateStatus: stateStatus ?? this.stateStatus,
    );
  }

  @override
  List<Object> get props => [expense, StateStatus];
}
