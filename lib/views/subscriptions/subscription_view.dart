import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';

import '../../controllers/property_controller.dart';
import '../../controllers/subscription_controller.dart';
import '../../helper/colors.dart';
import '../../models/subscription_plan.dart';

class SubscriptionView extends StatelessWidget {
  static const routeName = '/subscriptions';

  const SubscriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subscriptionController = Get.put(SubscriptionController());
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Platform.isAndroid
        ? Obx(() {
             if (subscriptionController.isLoading.value) {
               return const Center(
                 child: Padding(
                   padding: EdgeInsets.all(48.0),
                   child: CircularProgressIndicator(color: kPrimaryColor),
                 ),
               );
             }

             if (!subscriptionController.isAvailable.value) {
               return Center(
                 child: Padding(
                   padding: const EdgeInsets.all(24.0),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: kTextColor.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'In-app purchases are not available',
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Please make sure you are signed in to Google Play Store.',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )],
                  ),
                ),
              );
            }

             if (subscriptionController.errorMessage.value.isNotEmpty) {
               return Center(
                 child: Padding(
                   padding: const EdgeInsets.all(24.0),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(
                         Icons.error_outline,
                         size: 64,
                         color: kRedColor,
                       ),
                       const SizedBox(height: 16),
                       Text(
                         'Error loading subscriptions',
                         style: Theme.of(context).textTheme.titleLarge,
                         textAlign: TextAlign.center,
                       ),
                       const SizedBox(height: 8),
                       Text(
                         subscriptionController.errorMessage.value,
                         style: Theme.of(context).textTheme.bodyMedium,
                         textAlign: TextAlign.center,
                       ),
                       const SizedBox(height: 24),
                       ElevatedButton(
                         onPressed: () async {
                           await subscriptionController.loadProducts();
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: kPrimaryColor,
                           foregroundColor: kWhite,
                         ),
                         child: const Text('Retry'),
                       ),
                     ],
                   ),
                 ),
               );
             }

            return SingleChildScrollView(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Current Plan Card
                        _buildCurrentPlanCard(
                          context,
                          subscriptionController,
                          currencyFormat,
                        ),
                        const SizedBox(height: 24),

                        // Available Plans
                        Text(
                          'Available Plans',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: kTextColor,
                              ),
                        ),
                        const SizedBox(height: 16),

                        // Plans List
                        ...SubscriptionPlan.allPlans.map((plan) {
                          final isCurrentPlan = plan.tier == subscriptionController.currentTier;
                          final productDetails = subscriptionController.products.firstWhereOrNull((p) => p.id == plan.productId);

                          return _buildPlanCard(
                            context,
                            plan,
                            isCurrentPlan,
                            productDetails,
                            currencyFormat,
                            subscriptionController,
                          );
                        }).toList(),

                        const SizedBox(height: 24),

                        // Restore Purchases Button
                        OutlinedButton.icon(
                          onPressed: subscriptionController.isLoading.value ? null : () => subscriptionController.restorePurchases(),
                          icon: const Icon(Icons.restore),
                          label: const Text('Restore Purchases'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kPrimaryColor,
                            side: const BorderSide(color: kPrimaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          })
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 64,
                    color: kTextColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Subscriptions are only available on Android',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildCurrentPlanCard(
    BuildContext context,
    SubscriptionController controller,
    NumberFormat currencyFormat,
  ) {
    final currentPlan = controller.currentPlan;
    final propertyController = Get.find<PropertyController>();
    final currentCount = propertyController.properties.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kPrimaryColor,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: kPrimaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Current Plan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            SubscriptionPlan.displayName(currentPlan.tier),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kTextColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '${currentPlan.maxUnits == null ? 'Unlimited' : currentPlan.maxUnits} units allowed',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: kTextColor.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: currentPlan.maxUnits == null ? 0 : currentCount / currentPlan.maxUnits!,
            backgroundColor: kBackgroundVarientColor,
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),
          const SizedBox(height: 4),
          Text(
            '$currentCount / ${currentPlan.maxUnits ?? '∞'} units used',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: kTextColor.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    SubscriptionPlan plan,
    bool isCurrentPlan,
    ProductDetails? productDetails,
    NumberFormat currencyFormat,
    SubscriptionController controller,
  ) {
    final displayPrice = productDetails?.price ?? currencyFormat.format(plan.price);
    final isUpgrade = plan.tier.index > controller.currentTier.index;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCurrentPlan ? kPrimaryColor.withOpacity(0.1) : kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentPlan ? kPrimaryColor : kBackgroundVarientColor,
          width: isCurrentPlan ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.maxUnits == null
                            ? '201+ units'
                            : plan.maxUnits == 5
                                ? '1–5 units'
                                : plan.maxUnits == 15
                                    ? '6–15 units'
                                    : plan.maxUnits == 50
                                        ? '16–50 units'
                                        : plan.maxUnits == 100
                                            ? '51–100 units'
                                            : '100–200 units',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: kTextColor,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        displayPrice,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                if (isCurrentPlan)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Current',
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${plan.maxUnits == null ? 'Unlimited' : plan.maxUnits} units maximum',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: kTextColor.withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCurrentPlan ? null : () => controller.purchaseSubscription(plan),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCurrentPlan
                      ? kBackgroundVarientColor
                      : isUpgrade
                          ? kPrimaryColor
                          : kTextColor.withOpacity(0.5),
                  foregroundColor: isCurrentPlan ? kTextColor.withOpacity(0.5) : kWhite,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isCurrentPlan
                      ? 'Current Plan'
                      : isUpgrade
                          ? 'Upgrade'
                          : 'Downgrade',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
