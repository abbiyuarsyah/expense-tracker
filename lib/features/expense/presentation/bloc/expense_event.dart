import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';

import '../../../../core/enums/select_date_enum.dart';

abstract class ExpenseEvent {
  const ExpenseEvent();
}

class GetExpensesEvent extends ExpenseEvent {
  const GetExpensesEvent({required this.selectDate});

  final SelectDateEnum selectDate;
}

class AddExpenseEvent extends ExpenseEvent {
  const AddExpenseEvent({
    required this.amount,
    required this.category,
    required this.dateTime,
    required this.description,
  });

  final double amount;
  final int category;
  final DateTime dateTime;
  final String description;
}

class DeleteExpenseEvent extends ExpenseEvent {
  const DeleteExpenseEvent({required this.expense});

  final ExpenseEntity expense;
}

class GetWeeklyExpenseEvet extends ExpenseEvent {
  const GetWeeklyExpenseEvet();
}
