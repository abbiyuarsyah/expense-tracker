import 'package:equatable/equatable.dart';
import 'package:expense_tracker/core/enums/state_status_enum.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';

import '../../../../core/enums/expense_category_enum.dart';

class ExpenseState extends Equatable {
  const ExpenseState({
    required this.expenses,
    required this.getExpensesStatus,
    required this.addExpenseStatus,
    required this.deleteExpenseStatus,
    required this.weeklyExpenseStatus,
    required this.addExpenseFlag,
    required this.selectedDate,
    required this.weeklyExpensesByCategory,
    required this.totalExpenseInAWeek,
    required this.highestSpentCategory,
  });

  final List<ExpenseEntity> expenses;
  final StateStatus getExpensesStatus;
  final StateStatus addExpenseStatus;
  final StateStatus deleteExpenseStatus;
  final StateStatus weeklyExpenseStatus;
  final bool addExpenseFlag;
  final DateTime selectedDate;
  final Map<ExpenseCategoryEnum, double> weeklyExpensesByCategory;
  final double totalExpenseInAWeek;
  final int highestSpentCategory;

  ExpenseState copyWith({
    List<ExpenseEntity>? expenses,
    StateStatus? getExpensesStatus,
    StateStatus? addExpenseStatus,
    StateStatus? deleteExpenseStatus,
    StateStatus? weeklyExpenseStatus,
    bool? addExpenseFlag,
    DateTime? selectedDate,
    Map<ExpenseCategoryEnum, double>? weeklyExpensesByCategory,
    double? totalExpenseInAWeek,
    int? highestSpentCategory,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      getExpensesStatus: getExpensesStatus ?? this.getExpensesStatus,
      addExpenseStatus: addExpenseStatus ?? this.addExpenseStatus,
      deleteExpenseStatus: deleteExpenseStatus ?? this.deleteExpenseStatus,
      weeklyExpenseStatus: weeklyExpenseStatus ?? this.weeklyExpenseStatus,
      addExpenseFlag: addExpenseFlag ?? this.addExpenseFlag,
      selectedDate: selectedDate ?? this.selectedDate,
      weeklyExpensesByCategory:
          weeklyExpensesByCategory ?? this.weeklyExpensesByCategory,
      totalExpenseInAWeek: totalExpenseInAWeek ?? this.totalExpenseInAWeek,
      highestSpentCategory: highestSpentCategory ?? this.highestSpentCategory,
    );
  }

  @override
  List<Object> get props => [
        expenses,
        getExpensesStatus,
        addExpenseStatus,
        deleteExpenseStatus,
        weeklyExpenseStatus,
        addExpenseFlag,
        selectedDate,
        weeklyExpensesByCategory,
        totalExpenseInAWeek,
        highestSpentCategory,
      ];
}
