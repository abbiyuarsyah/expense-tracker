import 'package:expense_tracker/features/expense/data/models/expense_model.dart';
import 'package:hive/hive.dart';

abstract class ExpenseDatasource {
  Future<List<ExpenseModel>> getAll();
  Future<ExpenseModel> add(ExpenseModel entity);
  Future<bool> deleteEntity(ExpenseModel entity);
}

class ExpenseDatasourceImpl extends ExpenseDatasource {
  ExpenseDatasourceImpl._({required hiveInterface})
      : _hiveInterface = hiveInterface;

  final HiveInterface _hiveInterface;
  late Box _box;
  bool _initialized = false;

  static Future<ExpenseDatasourceImpl> create({required hiveInterface}) async {
    final repo = ExpenseDatasourceImpl._(hiveInterface: hiveInterface);

    await repo.init();
    return repo;
  }

  Future<void> init() async {
    bool isInitializing = false;
    if (_initialized == false && isInitializing == false) {
      isInitializing = true;
      _hiveInterface.registerAdapter(ExpenseModelAdapter());
      _initialized = true;
    }
  }

  @override
  Future<ExpenseModel> add(ExpenseModel entity) async {
    await _box.put(entity.id, entity);
    return Future.value(entity);
  }

  @override
  Future<bool> deleteEntity(ExpenseModel entity) async {
    final key = _box.keys.firstWhere(
      (k) => _box.get(k) == entity,
      orElse: () => null,
    );
    await _box.delete(key);

    return true;
  }

  @override
  Future<List<ExpenseModel>> getAll() async {
    final values = _box.values.toList().cast<ExpenseModel>();
    return values.isEmpty
        ? Future.value([ExpenseModel.empty()])
        : Future.value(values);
  }
}
