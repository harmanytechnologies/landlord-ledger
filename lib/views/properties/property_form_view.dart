import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/property_controller.dart';
import '../../helper/colors.dart';
import '../../widgets/custom_text_form_field.dart';

class PropertyFormView extends StatefulWidget {
  final String? propertyId;
  const PropertyFormView({Key? key, this.propertyId}) : super(key: key);

  @override
  State<PropertyFormView> createState() => _PropertyFormViewState();
}

class _PropertyFormViewState extends State<PropertyFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String _status = 'Vacant';
  File? _selectedImage;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<PropertyController>();
    if (widget.propertyId != null) {
      final property = controller.getById(widget.propertyId!);
      if (property != null) {
        _nameController.text = property.title;
        _notesController.text = property.notes ?? '';
        _status = property.status;
        _imagePath = property.photoPath;
        if (_imagePath != null && _imagePath!.isNotEmpty) {
          _selectedImage = File(_imagePath!);
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _imagePath = image.path;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyController>();

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
                          widget.propertyId == null ? 'Add Property' : 'Edit Property',
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
                          // Property Name
                          Text(
                            'Property Name',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          customTextFormField(
                            context,
                            hintText: 'e.g. 123 Main St - Unit 2B',
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a property name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Status Dropdown (Full Width)
                          Text(
                            'Status',
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
                                value: _status,
                                isExpanded: true,
                                isDense: true,
                                dropdownColor: kWhite,
                                style: Theme.of(context).textTheme.bodyMedium,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Occupied',
                                    child: Text('Occupied'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Vacant',
                                    child: Text('Vacant'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _status = value;
                                    });
                                  }
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
                            hintText: 'Enter notes about this property',
                            controller: _notesController,
                            maxLines: 6,
                            minLines: 5,
                          ),
                          const SizedBox(height: 16),
                          // Upload Image
                          Text(
                            'Upload Image (Optional)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: kBackgroundVarientColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: kTextColor.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: _selectedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 48,
                                          color: kTextColor.withOpacity(0.5),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Tap to upload image',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: kTextColor.withOpacity(0.6),
                                              ),
                                        ),
                                      ],
                                    ),
                            ),
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

                        if (widget.propertyId == null) {
                          controller.addProperty(
                            title: _nameController.text.trim(),
                            address: '', // Empty since not in form
                            status: _status,
                            photoPath: _imagePath,
                            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                          );
                        } else {
                          final existing = controller.getById(widget.propertyId!);
                          if (existing != null) {
                            controller.updateProperty(
                              existing.copyWith(
                                title: _nameController.text.trim(),
                                address: existing.address, // Keep existing
                                status: _status,
                                photoPath: _imagePath,
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
