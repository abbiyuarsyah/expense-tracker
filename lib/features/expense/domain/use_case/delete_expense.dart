import 'package:dartz/dartz.dart';

import '../../../../core/utils/execptions.dart';
import '../../../../core/utils/use_case.dart';
import '../../data/models/expense_model.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class DeletExpense extends UseCase<bool, ExpenseEntity> {
  DeletExpense({required this.repository});

  final ExpenseRepository repository;

  @override
  Future<Either<Failure, bool>> call(ExpenseEntity params) async {
    final result = await repository.delete(
      ExpenseModel(
        id: params.id,
        amount: params.amount,
        category: params.category,
        date: params.date,
        description: params.description,
      ),
    );

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
