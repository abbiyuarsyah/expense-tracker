import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/utils/execptions.dart';
import 'package:expense_tracker/features/expense/data/datasources/expense_datasource.dart';
import 'package:expense_tracker/features/expense/data/models/expense_model.dart';
import '../../domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl({required this.datasource});

  final ExpenseDatasource datasource;

  @override
  Future<Either<Failure, ExpenseModel>> add(ExpenseModel data) async {
    try {
      final result = await datasource.add(data);
      return Right(result);
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> delete(ExpenseModel data) async {
    try {
      final result = await datasource.deleteEntity(data);
      return Right(result);
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<ExpenseModel>>> get(DateTime? date) async {
    try {
      final result = await datasource.get(date);
      return Right(result);
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }
}
