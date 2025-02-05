import 'package:expense_tracker/features/expense/data/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

abstract class ExpenseDatasource {
  Future<List<ExpenseModel>> get(DateTime? date);
  Future<ExpenseModel> add(ExpenseModel model);
  Future<bool> deleteEntity(ExpenseModel model);
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
    await repo.open();

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
  Future<ExpenseModel> add(ExpenseModel model) async {
    await _box.put(model.id, model);
    return Future.value(model);
  }

  @override
  Future<bool> deleteEntity(ExpenseModel model) async {
    final key = _box.keys.firstWhere(
      (k) => _box.get(k) == model,
      orElse: () => null,
    );
    await _box.delete(key);

    return true;
  }

  @override
  Future<List<ExpenseModel>> get(DateTime? date) async {
    if (date == null) {
      return _box.values.toList().cast<ExpenseModel>();
    }

    final values = _box.values.toList().cast<ExpenseModel>();
    final result =
        values.where((e) => DateUtils.isSameDay(e.date, date)).toList();

    return result.isEmpty ? Future.value([]) : Future.value(result);
  }

  Future<void> open() async {
    _box = await _hiveInterface.openBox(ExpenseModel.boxName);
  }
}
