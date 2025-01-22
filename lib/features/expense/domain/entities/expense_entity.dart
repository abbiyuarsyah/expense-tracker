class ExpenseEntity {
  const ExpenseEntity({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  });

  final int id;
  final double amount;
  final int category;
  final DateTime date;
  final String description;
}
