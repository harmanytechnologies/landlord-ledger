import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../helper/hive_keys.dart';
import '../models/expense.dart';

class ExpenseController extends GetxController {
  static const String _boxKey = 'expenses';

  final RxList<Expense> expenses = <Expense>[].obs;

  late final Box _box;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box(HiveKeys.mainBox);
    _loadFromHive();
  }

  void _loadFromHive() {
    final list = _box.get(_boxKey);
    if (list is List) {
      expenses.assignAll(
        list.map((e) => Expense.fromMap(e as Map<dynamic, dynamic>)).toList(),
      );
    }
  }

  void _saveToHive() {
    final list = expenses.map((e) => e.toMap()).toList();
    _box.put(_boxKey, list);
  }

  Expense addExpense({
    required String title,
    required double amount,
    String? propertyId,
    required String category,
    required DateTime date,
    String? notes,
    String? receiptPath,
    bool isPaid = false,
  }) {
    final expense = Expense(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      propertyId: propertyId,
      category: category,
      date: date,
      notes: notes,
      receiptPath: receiptPath,
      isPaid: isPaid,
    );
    expenses.add(expense);
    _saveToHive();
    return expense;
  }

  void updateExpense(Expense updated) {
    final index = expenses.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      expenses[index] = updated;
      _saveToHive();
    }
  }

  void deleteExpense(Expense expense) {
    expenses.removeWhere((e) => e.id == expense.id);
    _saveToHive();
  }

  Expense? getById(String id) {
    try {
      return expenses.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Expense> getByPropertyId(String propertyId) {
    return expenses.where((e) => e.propertyId == propertyId).toList();
  }

  List<Expense> getByCategory(String category) {
    return expenses.where((e) => e.category == category).toList();
  }

  List<Expense> getPaid() {
    return expenses.where((e) => e.isPaid).toList();
  }

  List<Expense> getDue() {
    return expenses.where((e) => !e.isPaid).toList();
  }
}
