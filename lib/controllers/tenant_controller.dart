import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../helper/hive_keys.dart';
import '../models/tenant.dart';
import 'subscription_controller.dart';

class TenantController extends GetxController {
  static const String _boxKey = 'tenants';

  final RxList<Tenant> tenants = <Tenant>[].obs;

  late final Box _box;

  SubscriptionController get _subscriptionController =>
      Get.find<SubscriptionController>();

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box(HiveKeys.mainBox);
    _loadFromHive();
  }

  void _loadFromHive() {
    final list = _box.get(_boxKey);
    if (list is List) {
      tenants.assignAll(
        list.map((e) => Tenant.fromMap(e as Map<dynamic, dynamic>)).toList(),
      );
    }
  }

  void _saveToHive() {
    final list = tenants.map((t) => t.toMap()).toList();
    _box.put(_boxKey, list);
  }

  bool canAddMoreTenants() {
    return _subscriptionController.canAddProperty(tenants.length);
  }

  Tenant addTenant({
    required String name,
    String? email,
    String? phone,
    String? propertyId,
    String? notes,
  }) {
    final tenant = Tenant(
      id: const Uuid().v4(),
      name: name,
      email: email,
      phone: phone,
      propertyId: propertyId,
      notes: notes,
    );
    tenants.add(tenant);
    _saveToHive();
    return tenant;
  }

  void updateTenant(Tenant updated) {
    final index = tenants.indexWhere((t) => t.id == updated.id);
    if (index != -1) {
      tenants[index] = updated;
      _saveToHive();
    }
  }

  void deleteTenant(Tenant tenant) {
    tenants.removeWhere((t) => t.id == tenant.id);
    _saveToHive();
  }

  Tenant? getById(String id) {
    try {
      return tenants.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Tenant> getByPropertyId(String propertyId) {
    return tenants.where((t) => t.propertyId == propertyId).toList();
  }
}

