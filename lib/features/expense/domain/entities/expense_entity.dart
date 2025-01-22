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

  factory ExpenseEntity.empty() {
    return ExpenseEntity(
      id: 0,
      amount: 0,
      category: 1,
      date: DateTime.now(),
      description: '',
    );
  }
}
