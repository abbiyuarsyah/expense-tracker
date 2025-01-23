import 'package:expense_tracker/features/expense/data/datasources/expense_datasource.dart';
import 'package:expense_tracker/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repository.dart';
import 'package:expense_tracker/features/expense/domain/use_case/add_expense.dart';
import 'package:expense_tracker/features/expense/domain/use_case/delete_expense.dart';
import 'package:expense_tracker/features/expense/domain/use_case/get_expenses.dart';
import 'package:expense_tracker/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  /// Datasource
  sl.registerSingletonAsync<ExpenseDatasource>(() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(join(directory.path, 'local_storage'));

    return await ExpenseDatasourceImpl.create(hiveInterface: Hive);
  });

  // Wait for ExpenseDatasource to initialize
  await sl.isReady<ExpenseDatasource>();

  /// Repository
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(datasource: sl()),
  );

  /// User case
  sl.registerLazySingleton(() => GetExpenses(repository: sl()));
  sl.registerLazySingleton(() => AddExpense(repository: sl()));
  sl.registerLazySingleton(() => DeleteExpense(repository: sl()));

  /// Bloc
  sl.registerLazySingleton<ExpenseBloc>(
    () => ExpenseBloc(
      getExpenses: sl(),
      addExpense: sl(),
      deleteExpense: sl(),
    ),
  );
}
