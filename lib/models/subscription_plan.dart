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

  const SubscriptionPlan._(this.tier, this.maxUnits);

  static const SubscriptionPlan units1to5 =
      SubscriptionPlan._(SubscriptionPlanTier.units1to5, 5);
  static const SubscriptionPlan units6to15 =
      SubscriptionPlan._(SubscriptionPlanTier.units6to15, 15);
  static const SubscriptionPlan units16to50 =
      SubscriptionPlan._(SubscriptionPlanTier.units16to50, 50);
  static const SubscriptionPlan units51to100 =
      SubscriptionPlan._(SubscriptionPlanTier.units51to100, 100);
  static const SubscriptionPlan units101to200 =
      SubscriptionPlan._(SubscriptionPlanTier.units101to200, 200);
  static const SubscriptionPlan units201plus =
      SubscriptionPlan._(SubscriptionPlanTier.units201plus, null);

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
    switch (tier) {
      case SubscriptionPlanTier.units1to5:
        return "1–5 units (\$14.99/month)";
      case SubscriptionPlanTier.units6to15:
        return "6–15 units (\$24.99/month)";
      case SubscriptionPlanTier.units16to50:
        return "16–50 units (\$49.99/month)";
      case SubscriptionPlanTier.units51to100:
        return "51–100 units (\$99.99/month)";
      case SubscriptionPlanTier.units101to200:
        return "100–200 units (\$199.99/month)";
      case SubscriptionPlanTier.units201plus:
        return "201+ units (\$249.99/month)";
    }
  }

  bool canAddUnit(int currentUnitCount) {
    if (maxUnits == null) return true;
    return currentUnitCount < maxUnits!;
  }
}


