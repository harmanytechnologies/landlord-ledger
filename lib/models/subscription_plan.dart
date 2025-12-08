enum SubscriptionPlanTier {
  units1to5,
  units6to15,
  units16to50,
  units51to100,
  units101to200,
  units201plus,
}

class SubscriptionPlan {
  final SubscriptionPlanTier tier;
  final int? maxUnits; // null means unlimited
  final String productId; // Google Play product ID
  final double price; // Price in USD

  const SubscriptionPlan._(this.tier, this.maxUnits, this.productId, this.price);

  static const SubscriptionPlan units1to5 = SubscriptionPlan._(SubscriptionPlanTier.units1to5, 5, 'units_1_5', 14.99);
  static const SubscriptionPlan units6to15 = SubscriptionPlan._(SubscriptionPlanTier.units6to15, 15, 'units_6_15', 24.99);
  static const SubscriptionPlan units16to50 = SubscriptionPlan._(SubscriptionPlanTier.units16to50, 50, 'units_16_50', 49.99);
  static const SubscriptionPlan units51to100 = SubscriptionPlan._(SubscriptionPlanTier.units51to100, 100, 'units_51_100', 99.99);
  static const SubscriptionPlan units101to200 = SubscriptionPlan._(SubscriptionPlanTier.units101to200, 200, 'units_100_200', 199.99);
  static const SubscriptionPlan units201plus = SubscriptionPlan._(SubscriptionPlanTier.units201plus, null, 'units_201_plus', 249.99);

  static SubscriptionPlan fromTier(SubscriptionPlanTier tier) {
    switch (tier) {
      case SubscriptionPlanTier.units1to5:
        return units1to5;
      case SubscriptionPlanTier.units6to15:
        return units6to15;
      case SubscriptionPlanTier.units16to50:
        return units16to50;
      case SubscriptionPlanTier.units51to100:
        return units51to100;
      case SubscriptionPlanTier.units101to200:
        return units101to200;
      case SubscriptionPlanTier.units201plus:
        return units201plus;
    }
  }

  static String displayName(SubscriptionPlanTier tier) {
    final plan = fromTier(tier);
    return "${plan.maxUnits == null ? '201+' : plan.maxUnits == 5 ? '1–5' : plan.maxUnits == 15 ? '6–15' : plan.maxUnits == 50 ? '16–50' : plan.maxUnits == 100 ? '51–100' : '100–200'} units (\$${plan.price.toStringAsFixed(2)}/month)";
  }

  static List<SubscriptionPlan> get allPlans => [
        units1to5,
        units6to15,
        units16to50,
        units51to100,
        units101to200,
        units201plus,
      ];

  static SubscriptionPlan? fromProductId(String productId) {
    try {
      return allPlans.firstWhere((plan) => plan.productId == productId);
    } catch (_) {
      return null;
    }
  }

  bool canAddUnit(int currentUnitCount) {
    if (maxUnits == null) return true;
    return currentUnitCount < maxUnits!;
  }
}
