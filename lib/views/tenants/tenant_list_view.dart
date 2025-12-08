import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/property_controller.dart';
import '../../controllers/subscription_controller.dart';
import '../../controllers/tenant_controller.dart';
import '../../helper/colors.dart';
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: kBackgroundColor,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kTextColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Tenants',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: kTextColor,
                fontSize: 20,
              ),
        ),
        centerTitle: false,
      ),
      body: Obx(
        () {
          // Apply search filter by name, phone, email, or property name
          final query = _searchQuery.toLowerCase();
          final filteredTenants = tenantController.tenants.where((t) {
            if (query.isEmpty) return true;
            final name = t.name.toLowerCase();
            final email = (t.email ?? '').toLowerCase();
            final phone = (t.phone ?? '').toLowerCase();
            // Also search by property name
            String propertyName = '';
            if (t.propertyId != null) {
              final property = propertyController.getById(t.propertyId!);
              if (property != null) {
                propertyName = property.title.toLowerCase();
              }
            }
            return name.contains(query) || 
                   email.contains(query) || 
                   phone.contains(query) ||
                   propertyName.contains(query);
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
              placeholder: 'Search by name, phone, email, or property',
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
