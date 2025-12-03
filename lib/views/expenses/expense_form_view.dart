import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../controllers/expense_controller.dart';
import '../../controllers/property_controller.dart';
import '../../helper/colors.dart';
import '../../widgets/custom_text_form_field.dart';

class ExpenseFormView extends StatefulWidget {
  static const routeName = '/expenses/form';

  final String? expenseId;
  final String? propertyId; // Optional: pre-fill property when adding from property details

  const ExpenseFormView({Key? key, this.expenseId, this.propertyId}) : super(key: key);

  @override
  State<ExpenseFormView> createState() => _ExpenseFormViewState();
}

class _ExpenseFormViewState extends State<ExpenseFormView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? _selectedPropertyId;
  String _category = 'Other';
  DateTime _selectedDate = DateTime.now();
  File? _selectedReceipt;
  String? _receiptPath;

  // Expense categories
  final List<String> _categories = [
    'Maintenance',
    'Repairs',
    'Utilities',
    'Insurance',
    'Taxes',
    'Legal',
    'Marketing',
    'Cleaning',
    'Landscaping',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final expenseController = Get.find<ExpenseController>();

    // Pre-fill property if provided
    if (widget.propertyId != null) {
      _selectedPropertyId = widget.propertyId;
    }

    if (widget.expenseId != null) {
      final expense = expenseController.getById(widget.expenseId!);
      if (expense != null) {
        _titleController.text = expense.title;
        _amountController.text = expense.amount.toStringAsFixed(2);
        _selectedPropertyId = expense.propertyId ?? _selectedPropertyId;
        _category = expense.category;
        _selectedDate = expense.date;
        _notesController.text = expense.notes ?? '';
        _receiptPath = expense.receiptPath;
        if (_receiptPath != null && _receiptPath!.isNotEmpty) {
          _selectedReceipt = File(_receiptPath!);
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickReceipt() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedReceipt = File(image.path);
          _receiptPath = image.path;
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kSecondaryColor,
              onPrimary: Colors.white,
              onSurface: kTextColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseController = Get.put(ExpenseController());
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
                    // Large Title Section
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.expenseId == null ? 'Add Expense' : 'Edit Expense',
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
                          // Expense Title
                          Text(
                            'Expense Title',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          customTextFormField(
                            context,
                            hintText: 'e.g. Plumbing Repair',
                            controller: _titleController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter expense title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Amount
                          Text(
                            'Amount',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          customTextFormField(
                            context,
                            hintText: '0.00',
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter amount';
                              }
                              final amount = double.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return 'Please enter a valid amount';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Property Dropdown (Required - tied to a property)
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
                                hint: const Text('Select property'),
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
                          // Category Dropdown
                          Text(
                            'Category',
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
                                value: _category,
                                isExpanded: true,
                                isDense: true,
                                dropdownColor: kWhite,
                                style: Theme.of(context).textTheme.bodyMedium,
                                items: _categories.map((category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _category = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Due Date Picker
                          Text(
                            'Due Date',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: kBackgroundVarientColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(_selectedDate),
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: kTextColor.withOpacity(0.6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Notes (Optional)
                          Text(
                            'Notes (Optional)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          customTextFormField(
                            context,
                            hintText: 'Enter notes about this expense',
                            controller: _notesController,
                            maxLines: 6,
                            minLines: 5,
                          ),
                          const SizedBox(height: 16),
                          // Attach Receipt (Optional)
                          Text(
                            'Attach Receipt (Optional)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: _pickReceipt,
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
                              child: _selectedReceipt != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        _selectedReceipt!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.receipt_long_outlined,
                                          size: 48,
                                          color: kTextColor.withOpacity(0.5),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Tap to attach receipt',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: kTextColor.withOpacity(0.6),
                                              ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 100), // Extra space for bottom button
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Fixed Bottom Button
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
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    // Validate property is selected (expense is tied to a property)
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

                    final amount = double.parse(_amountController.text.trim());

                    if (widget.expenseId == null) {
                      expenseController.addExpense(
                        title: _titleController.text.trim(),
                        amount: amount,
                        propertyId: _selectedPropertyId,
                        category: _category,
                        date: _selectedDate,
                        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                        receiptPath: _receiptPath,
                      );
                    } else {
                      final existing = expenseController.getById(widget.expenseId!);
                      if (existing != null) {
                        expenseController.updateExpense(
                          existing.copyWith(
                            title: _titleController.text.trim(),
                            amount: amount,
                            propertyId: _selectedPropertyId,
                            category: _category,
                            date: _selectedDate,
                            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                            receiptPath: _receiptPath,
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
            ),
          ),
        ],
      ),
    );
  }
}
