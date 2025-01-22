import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';

abstract class ExpenseEvent {
  const ExpenseEvent();
}

class GetExpensesEvent extends ExpenseEvent {
  const GetExpensesEvent();
}

class AddExpenseEvent extends ExpenseEvent {
  const AddExpenseEvent({required this.expense});

  final ExpenseEntity expense;
}

class DeleteExpenseEvent extends ExpenseEvent {
  const DeleteExpenseEvent({required this.expense});

  final ExpenseEntity expense;
}
