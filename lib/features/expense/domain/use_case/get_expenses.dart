import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/utils/execptions.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repository.dart';

import '../../../../core/utils/use_case.dart';

class GetExpenses extends UseCase<List<ExpenseEntity>, ExpenseEntity> {
  GetExpenses({required this.repository});

  final ExpenseRepository repository;

  @override
  Future<Either<Failure, List<ExpenseEntity>>> call(
      ExpenseEntity params) async {
    final result = await repository.getAll();

    return result.fold(
      (l) => Left(l),
      (r) => Right(
        r
            .map(
              (e) => ExpenseEntity(
                id: e.id,
                amount: e.amount,
                category: e.category,
                date: e.date,
                description: e.description,
              ),
            )
            .toList(),
      ),
    );
  }
}
