import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/property_controller.dart';
import '../../controllers/tenant_controller.dart';
import '../../helper/colors.dart';
import '../../widgets/custom_text_form_field.dart';

class TenantFormView extends StatefulWidget {
  final String? tenantId;
  final String? propertyId; // Optional: pre-fill property when adding from property details
  const TenantFormView({Key? key, this.tenantId, this.propertyId}) : super(key: key);

  @override
  State<TenantFormView> createState() => _TenantFormViewState();
}

class _TenantFormViewState extends State<TenantFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedPropertyId; // Required - tenant must be assigned to a property

  @override
  void initState() {
    super.initState();
    final controller = Get.find<TenantController>();

    // Pre-fill property if provided (when adding tenant from property details)
    if (widget.propertyId != null) {
      _selectedPropertyId = widget.propertyId;
    }

    if (widget.tenantId != null) {
      final tenant = controller.getById(widget.tenantId!);
      if (tenant != null) {
        _nameController.text = tenant.name;
        _emailController.text = tenant.email ?? '';
        _phoneController.text = tenant.phone ?? '';
        _notesController.text = tenant.notes ?? '';
        _selectedPropertyId = tenant.propertyId ?? _selectedPropertyId;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TenantController());
    final propertyController = Get.find<PropertyController>();

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
      body: Column(
        children: [
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Large Title Section (Scrollable)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.tenantId == null ? 'Add Tenant' : 'Edit Tenant',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: kTextColor,
                                fontSize: 34,
                              ),
                        ),
                      ),
                    ),
                    // Form Content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tenant Name
                          Text(
                            'Name',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          customTextFormField(
                            context,
                            hintText: 'Enter tenant name',
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Email
                          Text(
                            'Email (Optional)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          customTextFormField(
                            context,
                            hintText: 'Enter email address',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          // Phone
                          Text(
                            'Phone (Optional)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          customTextFormField(
                            context,
                            hintText: 'Enter phone number',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          // Property Dropdown (Required)
                          Text(
                            'Property',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              color: kBackgroundVarientColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedPropertyId,
                                isExpanded: true,
                                isDense: true,
                                dropdownColor: kWhite,
                                style: Theme.of(context).textTheme.bodyMedium,
                                hint: Text(
                                  'Select property',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: kTextColor.withOpacity(0.5),
                                      ),
                                ),
                                items: propertyController.properties.map((property) {
                                  return DropdownMenuItem<String>(
                                    value: property.id,
                                    child: Text(property.title),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPropertyId = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Notes (Multiline)
                          Text(
                            'Notes (Optional)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          customTextFormField(
                            context,
                            hintText: 'Enter notes about this tenant',
                            controller: _notesController,
                            maxLines: 6,
                            minLines: 5,
                          ),
                          const SizedBox(height: 100), // Extra space for bottom buttons
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Fixed Bottom Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: kSecondaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        // Validate property is selected
                        if (_selectedPropertyId == null || _selectedPropertyId!.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please select a property',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: kRedColor.withOpacity(0.9),
                            colorText: Colors.white,
                          );
                          return;
                        }

                        if (widget.tenantId == null) {
                          controller.addTenant(
                            name: _nameController.text.trim(),
                            email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
                            phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
                            propertyId: _selectedPropertyId,
                            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                          );
                        } else {
                          final existing = controller.getById(widget.tenantId!);
                          if (existing != null) {
                            controller.updateTenant(
                              existing.copyWith(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
                                phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
                                propertyId: _selectedPropertyId,
                                notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                              ),
                            );
                          }
                        }

                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSecondaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
