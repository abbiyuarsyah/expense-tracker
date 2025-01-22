import 'package:equatable/equatable.dart';
import 'package:expense_tracker/core/enums/state_status_enum.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';

class ExpenseState extends Equatable {
  const ExpenseState({
    required this.expenses,
    required this.getExpensesStatus,
    required this.addExpenseStatus,
    required this.deleteExpenseStatus,
    required this.addExpenseFlag,
    required this.selectedDate,
    required this.weeklySpent,
  });

  final List<ExpenseEntity> expenses;
  final StateStatus getExpensesStatus;
  final StateStatus addExpenseStatus;
  final StateStatus deleteExpenseStatus;
  final bool addExpenseFlag;
  final DateTime selectedDate;
  final double weeklySpent;

  ExpenseState copyWith({
    List<ExpenseEntity>? expenses,
    StateStatus? getExpensesStatus,
    StateStatus? addExpenseStatus,
    StateStatus? deleteExpenseStatus,
    bool? addExpenseFlag,
    DateTime? selectedDate,
    double? weeklySpent,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      getExpensesStatus: getExpensesStatus ?? this.getExpensesStatus,
      addExpenseStatus: addExpenseStatus ?? this.addExpenseStatus,
      deleteExpenseStatus: deleteExpenseStatus ?? this.deleteExpenseStatus,
      addExpenseFlag: addExpenseFlag ?? this.addExpenseFlag,
      selectedDate: selectedDate ?? this.selectedDate,
      weeklySpent: weeklySpent ?? this.weeklySpent,
    );
  }

  @override
  List<Object> get props => [
        expenses,
        getExpensesStatus,
        addExpenseStatus,
        deleteExpenseStatus,
        addExpenseFlag,
        selectedDate,
        weeklySpent,
      ];
}
