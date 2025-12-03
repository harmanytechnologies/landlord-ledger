import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/property_controller.dart';
import '../../controllers/tenant_controller.dart';
import '../../helper/colors.dart';

class TenantDetailView extends StatelessWidget {
  final String tenantId;

  const TenantDetailView({Key? key, required this.tenantId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tenantController = Get.put(TenantController());
    final propertyController = Get.find<PropertyController>();
    final tenant = tenantController.getById(tenantId);

    if (tenant == null) {
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
          child: Text('Tenant not found'),
        ),
      );
    }

    final property = tenant.propertyId != null
        ? propertyController.getById(tenant.propertyId!)
        : null;

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large Title Section (Scrollable)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tenant Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                        fontSize: 34,
                      ),
                ),
              ),
            ),
            // Tenant Information
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tenant Avatar and Name
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: kPrimaryColor,
                            size: 50,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tenant.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: kTextColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Contact Information
                  if (tenant.email != null && tenant.email!.isNotEmpty) ...[
                    _buildInfoRow(context, Icons.email_outlined, 'Email', tenant.email!),
                    const SizedBox(height: 16),
                  ],
                  if (tenant.phone != null && tenant.phone!.isNotEmpty) ...[
                    _buildInfoRow(context, Icons.phone_outlined, 'Phone', tenant.phone!),
                    const SizedBox(height: 16),
                  ],
                  // Property
                  if (property != null) ...[
                    _buildInfoRow(
                      context,
                      Icons.home_outlined,
                      'Property',
                      property.title,
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Notes
                  if (tenant.notes != null && tenant.notes!.trim().isNotEmpty) ...[
                    Text(
                      'Notes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tenant.notes!,
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
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: kTextColor.withOpacity(0.6),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: kTextColor.withOpacity(0.6),
                      fontSize: 12,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: kTextColor,
                      fontSize: 14,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

