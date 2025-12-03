import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../controllers/property_controller.dart';
import '../../controllers/subscription_controller.dart';
import '../../controllers/tenant_controller.dart';
import '../../helper/colors.dart';
import '../../widgets/custom_appbar.dart';
import 'tenant_detail_view.dart';
import 'tenant_form_view.dart';

class TenantListView extends StatefulWidget {
  static const routeName = '/tenants';

  const TenantListView({Key? key}) : super(key: key);

  @override
  State<TenantListView> createState() => _TenantListViewState();
}

class _TenantListViewState extends State<TenantListView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tenantController = Get.put(TenantController());
    final subscriptionController = Get.put(SubscriptionController());
    final propertyController = Get.find<PropertyController>();
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
          // Apply search filter by name, phone, email
          final query = _searchQuery.toLowerCase();
          final filteredTenants = tenantController.tenants.where((t) {
            if (query.isEmpty) return true;
            final name = t.name.toLowerCase();
            final email = (t.email ?? '').toLowerCase();
            final phone = (t.phone ?? '').toLowerCase();
            return name.contains(query) || email.contains(query) || phone.contains(query);
          }).toList();

          return _buildTenantsList(
            context,
            tenantController,
            propertyController,
            filteredTenants,
          );
        },
      ),
      floatingActionButton: Obx(
        () {
          if (tenantController.tenants.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () {
              final canAdd = subscriptionController.canAddProperty(tenantController.tenants.length);
              if (!canAdd) {
                _showUpgradeDialog(context);
                return;
              }
              Get.to(() => const TenantFormView());
            },
            backgroundColor: kSecondaryColor,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Tenant',
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

  Widget _buildTenantsList(
    BuildContext context,
    TenantController tenantController,
    PropertyController propertyController,
    List tenants,
  ) {
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
                child: _buildSummaryCard(
                  context,
                  'Tenants',
                  tenantController.tenants.length.toString(),
                  Icons.people_outline,
                  kGreenColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Reminders',
                  '0', // TODO: Get actual reminder count
                  Icons.notifications_outlined,
                  kRedColor,
                ),
              ),
            ],
          ),
        ),
        // iOS-styled Search Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: kBackgroundVarientColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: CupertinoSearchTextField(
              controller: _searchController,
              placeholder: 'Search by name, phone, or email',
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: Theme.of(context).textTheme.bodyMedium,
              placeholderStyle: TextStyle(
                color: kTextColor.withOpacity(0.5),
              ),
              decoration: BoxDecoration(
                color: kBackgroundVarientColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        // Tenants List
        Expanded(
          child: tenants.isEmpty
              ? Center(
                  child: Text(
                    'No tenants match your search',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kTextColor.withOpacity(0.6),
                        ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final tenant = tenants[index];
                    return _buildTenantCard(context, tenant, tenantController, propertyController);
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemCount: tenants.length,
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

  Widget _buildTenantCard(BuildContext context, tenant, TenantController tenantController, PropertyController propertyController) {
    final property = tenant.propertyId != null ? propertyController.getById(tenant.propertyId!) : null;

    return InkWell(
      onTap: () {
        Get.to(() => TenantDetailView(tenantId: tenant.id));
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
            // Tenant Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.person,
                color: kPrimaryColor,
                size: 36,
              ),
            ),
            const SizedBox(width: 16),
            // Tenant Name and Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tenant.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: kTextColor,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (property != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.home_outlined,
                          size: 14,
                          color: kTextColor.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.title,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: kTextColor.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (tenant.phone != null && tenant.phone!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: kTextColor.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tenant.phone!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: kTextColor.withOpacity(0.7),
                                fontSize: 13,
                              ),
                        ),
                      ],
                    ),
                  ],
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
                  Get.to(() => TenantFormView(tenantId: tenant.id));
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context, tenant, tenantController);
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

  void _showDeleteConfirmation(BuildContext context, tenant, TenantController tenantController) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Tenant',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete "${tenant.name}"? This action cannot be undone.',
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
                tenantController.deleteTenant(tenant);
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
            'Please upgrade to the next plan to add more tenants.',
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
