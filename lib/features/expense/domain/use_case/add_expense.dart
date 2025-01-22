import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/utils/execptions.dart';
import 'package:expense_tracker/features/expense/data/models/expense_model.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repository.dart';

import '../../../../core/utils/use_case.dart';

class AddExpense extends UseCase<ExpenseEntity, ExpenseEntity> {
  AddExpense({required this.repository});

  final ExpenseRepository repository;

  @override
  Future<Either<Failure, ExpenseEntity>> call(ExpenseEntity params) async {
    final result = await repository.add(
      ExpenseModel(
        id: params.id,
        amount: params.amount,
        category: params.category,
        date: params.date,
        description: params.description,
      ),
    );

    return result.fold(
      (l) => Left(l),
      (r) => Right(
        ExpenseEntity(
          id: r.id,
          amount: r.amount,
          category: r.category,
          date: r.date,
          description: r.description,
        ),
      ),
    );
  }
}
