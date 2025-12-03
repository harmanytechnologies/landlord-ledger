import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/property_controller.dart';
import '../../controllers/tenant_controller.dart';
import '../../helper/colors.dart';
import '../tenants/tenant_detail_view.dart';
import '../tenants/tenant_form_view.dart';

class PropertyDetailView extends StatefulWidget {
  final String propertyId;

  const PropertyDetailView({Key? key, required this.propertyId}) : super(key: key);

  @override
  State<PropertyDetailView> createState() => _PropertyDetailViewState();
}

class _PropertyDetailViewState extends State<PropertyDetailView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyController>();
    final property = controller.getById(widget.propertyId);

    if (property == null) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
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
        ),
        body: const Center(
          child: Text('Property not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
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
          'Property Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: kTextColor,
              ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPropertyDetailsTab(context, property),
          _buildTenantsTab(context, widget.propertyId),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: kPrimaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          onTap: (index) {
            setState(() {
              _currentTabIndex = index;
              _tabController.animateTo(index);
            });
          },
          backgroundColor: kPrimaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.7),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              activeIcon: Icon(Icons.info),
              label: 'Details',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Tenants',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentTabIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                Get.to(() => TenantFormView(propertyId: widget.propertyId));
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
            )
          : null,
    );
  }

  Widget _buildPropertyDetailsTab(BuildContext context, property) {
    final isOccupied = property.status.toLowerCase() == 'occupied';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image
          if (property.photoPath != null && property.photoPath!.isNotEmpty)
            Container(
              width: double.infinity,
              height: 250,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(property.photoPath!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          // Property Information
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property Name Section
                Text(
                  property.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: kTextColor,
                      ),
                ),
                const SizedBox(height: 8),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: !isOccupied ? kGreenColor.withOpacity(0.15) : kRedColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: !isOccupied ? kGreenColor : kRedColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        property.status,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: !isOccupied ? kGreenColor : kRedColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Notes Section
                if (property.notes != null && property.notes!.trim().isNotEmpty) ...[
                  _sectionHeader(context, 'Notes'),
                  const SizedBox(height: 12),
                  Text(
                    property.notes!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kTextColor,
                          fontSize: 14,
                          height: 1.6,
                        ),
                  ),
                  const SizedBox(height: 32),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTenantsTab(BuildContext context, String propertyId) {
    final tenantController = Get.put(TenantController());

    return Obx(
      () {
        final allTenants = tenantController.getByPropertyId(propertyId);

        // Apply search filter by name, phone, email
        final query = _searchQuery.toLowerCase();
        final filteredTenants = allTenants.where((t) {
          if (query.isEmpty) return true;
          final name = t.name.toLowerCase();
          final email = (t.email ?? '').toLowerCase();
          final phone = (t.phone ?? '').toLowerCase();
          return name.contains(query) || email.contains(query) || phone.contains(query);
        }).toList();

        return Column(
          children: [
            // iOS-styled Search Field
            Padding(
              padding: const EdgeInsets.all(16),
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
            // Tenants List or Empty State
            Expanded(
              child: filteredTenants.isEmpty
                  ? Center(
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
                                allTenants.isEmpty ? Icons.people_outline : Icons.search_off,
                                size: 60,
                                color: kSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              allTenants.isEmpty ? 'No Tenants' : 'No Results',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: kTextColor,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              allTenants.isEmpty ? 'No tenants assigned to this property.\nTap "Add Tenant" to get started.' : 'No tenants match your search.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: kTextColor.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredTenants.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final tenant = filteredTenants[index];
                        return _buildTenantCard(context, tenant);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
    );
  }

  Widget _buildTenantCard(BuildContext context, tenant) {
    final tenantController = Get.find<TenantController>();

    return InkWell(
      onTap: () {
        Get.to(() => TenantDetailView(tenantId: tenant.id));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: kBackgroundVarientColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.person,
                color: kPrimaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
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
                  ),
                  if (tenant.phone != null && tenant.phone!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      tenant.phone!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: kTextColor.withOpacity(0.7),
                            fontSize: 13,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: kTextColor.withOpacity(0.6),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  Get.to(() => TenantFormView(tenantId: tenant.id, propertyId: widget.propertyId));
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
}
