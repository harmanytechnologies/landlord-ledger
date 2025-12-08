import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../helper/hive_keys.dart';
import '../models/ledger.dart';

class LedgerController extends GetxController {
  static const String _boxKey = 'ledgers';

  final RxList<LedgerEntry> ledgers = <LedgerEntry>[].obs;

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
      ledgers.assignAll(
        list.map((e) => LedgerEntry.fromMap(e as Map<dynamic, dynamic>)).toList(),
      );
    }
  }

  void _saveToHive() {
    final list = ledgers.map((e) => e.toMap()).toList();
    _box.put(_boxKey, list);
  }

  LedgerEntry addLedger({
    required String title,
    required double amount,
    required String type, // 'Income' or 'Expense'
    String? propertyId,
    required DateTime date,
    String? notes,
  }) {
    final entry = LedgerEntry(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      propertyId: propertyId,
      type: type,
      date: date,
      notes: notes,
    );
    ledgers.add(entry);
    _saveToHive();
    return entry;
  }

  void updateLedger(LedgerEntry updated) {
    final index = ledgers.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      ledgers[index] = updated;
      _saveToHive();
    }
  }

  void deleteLedger(LedgerEntry entry) {
    ledgers.removeWhere((e) => e.id == entry.id);
    _saveToHive();
  }

  LedgerEntry? getById(String id) {
    try {
      return ledgers.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<LedgerEntry> getByPropertyId(String propertyId) {
    return ledgers.where((e) => e.propertyId == propertyId).toList();
  }

  List<LedgerEntry> getIncome() {
    return ledgers.where((e) => e.type.toLowerCase() == 'income').toList();
  }

  List<LedgerEntry> getExpenses() {
    return ledgers.where((e) => e.type.toLowerCase() == 'expense').toList();
  }
}

