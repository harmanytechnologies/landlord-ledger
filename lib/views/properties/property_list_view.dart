import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/property_controller.dart';
import '../../controllers/reminder_controller.dart';
import '../../controllers/subscription_controller.dart';
import '../../controllers/tenant_controller.dart';
import '../../helper/colors.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';
import '../reminders/reminder_list_view.dart';
import '../tenants/tenant_list_view.dart';
import 'property_detail_view.dart';
import 'property_form_view.dart';

class PropertyListView extends StatelessWidget {
  static const routeName = '/properties';

  const PropertyListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final propertyController = Get.put(PropertyController());
    final subscriptionController = Get.put(SubscriptionController());
    final tenantController = Get.put(TenantController());

    return Scaffold(
      appBar: CustomAppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 32,
              width: 32,
            ),
            const SizedBox(width: 8),
            Text(
              'Landlord Ledger',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
            ),
          ],
        ),
      ),
      body: Obx(
        () {
          if (propertyController.properties.isEmpty) {
            return _buildEmptyState(context, propertyController, subscriptionController);
          }

          return _buildPropertiesList(context, propertyController, tenantController);
        },
      ),
      floatingActionButton: Obx(
        () {
          if (propertyController.properties.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () {
              final canAdd = subscriptionController.canAddProperty(propertyController.properties.length);
              if (!canAdd) {
                _showUpgradeDialog(context);
                return;
              }
              Get.to(() => const PropertyFormView());
            },
            backgroundColor: kSecondaryColor,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Property',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, PropertyController propertyController, SubscriptionController subscriptionController) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.home_outlined,
                size: 60,
                color: kSecondaryColor,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Ledgers',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: kTextColor,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start managing your properties by adding your first property',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: kTextColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: customButton(
                onPressed: () {
                  final canAdd = subscriptionController.canAddProperty(propertyController.properties.length);
                  if (!canAdd) {
                    _showUpgradeDialog(context);
                    return;
                  }
                  Get.to(() => const PropertyFormView());
                },
                child: const Text(
                  'Add Property',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertiesList(BuildContext context, PropertyController propertyController, TenantController tenantController) {
    final reminderController = Get.put(ReminderController());

    return Column(
      children: [
        // Summary Cards
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Properties',
                  propertyController.properties.length.toString(),
                  Icons.home_rounded,
                  kPrimaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => InkWell(
                    onTap: () {
                      Get.to(() => const TenantListView());
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: _buildSummaryCard(
                      context,
                      'Tenants',
                      tenantController.tenants.where((t) => t.propertyId != null && t.propertyId!.isNotEmpty).length.toString(),
                      Icons.people_outline,
                      kSecondaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => InkWell(
                    onTap: () {
                      Get.to(() => const ReminderListView());
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: _buildSummaryCard(
                      context,
                      'Reminders',
                      reminderController.reminders.length.toString(),
                      Icons.notifications_outlined,
                      kRedColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Properties List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final property = propertyController.properties[index];
              return _buildPropertyCard(context, property, propertyController);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: propertyController.properties.length,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String label,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: kTextColor,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: kTextColor.withOpacity(0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(BuildContext context, property, PropertyController propertyController) {
    final isOccupied = property.status.toLowerCase() == 'vacant';
    final hasImage = property.photoPath != null && property.photoPath!.isNotEmpty;

    return InkWell(
      onTap: () {
        Get.to(() => PropertyDetailView(propertyId: property.id));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: kBackgroundVarientColor,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Property Image
            if (hasImage)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(property.photoPath!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.home_rounded,
                  color: kPrimaryColor,
                  size: 36,
                ),
              ),
            const SizedBox(width: 16),
            // Property Name and Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: kTextColor,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOccupied ? kGreenColor.withOpacity(0.15) : kRedColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isOccupied ? kGreenColor : kRedColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          property.status,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isOccupied ? kGreenColor : kRedColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                size: 20,
                color: kTextColor.withOpacity(0.5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onSelected: (value) {
                if (value == 'edit') {
                  Get.to(() => PropertyFormView(propertyId: property.id));
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context, property, propertyController);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 18, color: kRedColor),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: kRedColor)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, property, PropertyController propertyController) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Property',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete "${property.title}"? This action cannot be undone.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: kTextColor),
              ),
            ),
            TextButton(
              onPressed: () {
                propertyController.deleteProperty(property);
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: kRedColor, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kWhite,
          title: Text(
            'Upgrade plan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'You have reached the maximum number of units allowed by your current subscription plan.\n\n'
            'Please upgrade to the next plan to add more properties.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: kPrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
