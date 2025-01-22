import 'package:equatable/equatable.dart';
import 'package:expense_tracker/core/enums/state_status.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';

class ExpenseState extends Equatable {
  const ExpenseState({
    required this.expenses,
    required this.getExpensesStatus,
    required this.addExpenseStatus,
    required this.addExpenseFlag,
  });

  final List<ExpenseEntity> expenses;
  final StateStatus getExpensesStatus;
  final StateStatus addExpenseStatus;
  final bool addExpenseFlag;

  ExpenseState copyWith({
    List<ExpenseEntity>? expenses,
    StateStatus? getExpensesStatus,
    StateStatus? addExpenseStatus,
    bool? addExpenseFlag,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      getExpensesStatus: getExpensesStatus ?? this.getExpensesStatus,
      addExpenseStatus: addExpenseStatus ?? this.addExpenseStatus,
      addExpenseFlag: addExpenseFlag ?? this.addExpenseFlag,
    );
  }

  @override
  List<Object> get props => [
        expenses,
        getExpensesStatus,
        addExpenseStatus,
        addExpenseFlag,
      ];
}
