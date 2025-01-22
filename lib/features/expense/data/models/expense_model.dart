import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 1)
class ExpenseModel {
  const ExpenseModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  });

  static const String boxName = 'ExpenseModel';

  @HiveField(0)
  final int id;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final int category;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String description;

  factory ExpenseModel.empty() {
    return ExpenseModel(
      id: -1,
      amount: 0,
      category: -1,
      date: DateTime.now(),
      description: '',
    );
  }
}
