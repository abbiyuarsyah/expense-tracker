import 'package:expense_tracker/features/expense/data/datasources/expense_datasource.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final GetIt sl = GetIt.instance;
Future<void> init() async {
  /// Core
  sl.registerLazySingleton(() => InternetConnection());

  /// Datasource
  sl.registerSingletonAsync<ExpenseDatasource>(() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(join(directory.path, 'local_storage'));

    return await ExpenseDatasourceImpl.create(
      hiveInterface: Hive,
    );
  });
}
