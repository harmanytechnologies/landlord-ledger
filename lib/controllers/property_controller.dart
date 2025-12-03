import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../helper/hive_keys.dart';
import '../models/property.dart';
import 'subscription_controller.dart';

class PropertyController extends GetxController {
  static const String _boxKey = 'properties';

  final RxList<Property> properties = <Property>[].obs;

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
      properties.assignAll(
        list.map((e) => Property.fromMap(e as Map<dynamic, dynamic>)).toList(),
      );
    }
  }

  void _saveToHive() {
    final list = properties.map((p) => p.toMap()).toList();
    _box.put(_boxKey, list);
  }

  bool canAddMoreProperties() {
    return _subscriptionController.canAddProperty(properties.length);
  }

  Property addProperty({
    required String title,
    required String address,
    required String status,
    String? photoPath,
    String? notes,
  }) {
    final property = Property(
      id: const Uuid().v4(),
      title: title,
      address: address,
      status: status,
      photoPath: photoPath,
      notes: notes,
    );
    properties.add(property);
    _saveToHive();
    return property;
  }

  void updateProperty(Property updated) {
    final index = properties.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      properties[index] = updated;
      _saveToHive();
    }
  }

  void deleteProperty(Property property) {
    properties.removeWhere((p) => p.id == property.id);
    _saveToHive();
  }

  Property? getById(String id) {
    try {
      return properties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}


