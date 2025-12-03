import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../helper/hive_keys.dart';
import '../models/subscription_plan.dart';

class SubscriptionController extends GetxController {
  static const String _planKey = 'current_subscription_tier';

  final Rx<SubscriptionPlanTier> _currentTier =
      SubscriptionPlanTier.units1to5.obs;

  SubscriptionPlanTier get currentTier => _currentTier.value;
  SubscriptionPlan get currentPlan => SubscriptionPlan.fromTier(currentTier);

  @override
  void onInit() {
    super.onInit();
    _loadFromHive();
  }

  void _loadFromHive() {
    final box = Hive.box(HiveKeys.mainBox);
    final stored = box.get(_planKey);
    if (stored is int && stored >= 0 && stored < SubscriptionPlanTier.values.length) {
      _currentTier.value = SubscriptionPlanTier.values[stored];
    }
  }

  void setTier(SubscriptionPlanTier tier) {
    _currentTier.value = tier;
    final box = Hive.box(HiveKeys.mainBox);
    box.put(_planKey, tier.index);
  }

  bool canAddProperty(int currentPropertyCount) {
    return currentPlan.canAddUnit(currentPropertyCount);
  }
}


