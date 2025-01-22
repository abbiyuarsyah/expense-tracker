import 'package:expense_tracker/core/utils/execptions.dart';
import 'package:dartz/dartz.dart';
import 'package:expense_tracker/features/expense/data/models/expense_model.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, ExpenseModel>> add(ExpenseModel data);
  Future<Either<Failure, bool>> delete(ExpenseModel data);
  Future<Either<Failure, List<ExpenseModel>>> get(DateTime date);
}
