import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/ledger_controller.dart';
import '../../controllers/property_controller.dart';
import '../../helper/colors.dart';
import '../../widgets/custom_text_form_field.dart';

class LedgerFormView extends StatefulWidget {
  static const routeName = '/ledgers/form';

  final String? ledgerId;
  final String? propertyId;

  const LedgerFormView({Key? key, this.ledgerId, this.propertyId}) : super(key: key);

  @override
  State<LedgerFormView> createState() => _LedgerFormViewState();
}

class _LedgerFormViewState extends State<LedgerFormView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _type = 'Income';
  DateTime _selectedDate = DateTime.now();
  String? _selectedPropertyId;

  @override
  void initState() {
    super.initState();
    final ledgerController = Get.put(LedgerController());

    // Pre-fill property if provided
    if (widget.propertyId != null) {
      _selectedPropertyId = widget.propertyId;
    }

    if (widget.ledgerId != null) {
      final ledger = ledgerController.getById(widget.ledgerId!);
      if (ledger != null) {
        _titleController.text = ledger.title;
        _amountController.text = ledger.amount.toStringAsFixed(2);
        _selectedPropertyId = ledger.propertyId ?? _selectedPropertyId;
        _type = ledger.type;
        _selectedDate = ledger.date;
        _notesController.text = ledger.notes ?? '';
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
    final ledgerController = Get.put(LedgerController());
    final propertyController = Get.find<PropertyController>();
    final dateFormat = DateFormat('MMM dd, yyyy');

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
                          widget.ledgerId == null ? 'Add Ledger Entry' : 'Edit Ledger Entry',
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
                          Text(
                            'Title',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          customTextFormField(
                            context,
                            hintText: 'e.g. Rent Payment',
                            controller: _titleController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
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
                                return 'Enter a valid amount';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Type',
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
                                value: _type,
                                isExpanded: true,
                                isDense: true,
                                dropdownColor: kWhite,
                                style: Theme.of(context).textTheme.bodyMedium,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Income',
                                    child: Text('Income'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Expense',
                                    child: Text('Expense'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _type = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Payment Date',
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dateFormat.format(_selectedDate),
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: kTextColor,
                                        ),
                                  ),
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: kTextColor.withOpacity(0.6),
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
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
                                hint: const Text('Select property'),
                                style: Theme.of(context).textTheme.bodyMedium,
                                items: propertyController.properties
                                    .map(
                                      (p) => DropdownMenuItem<String>(
                                        value: p.id,
                                        child: Text(p.title),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPropertyId = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Notes (Optional)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          customTextFormField(
                            context,
                            hintText: 'Add notes about this entry',
                            controller: _notesController,
                            maxLines: 5,
                            minLines: 4,
                          ),
                          const SizedBox(height: 100), // Space for bottom buttons
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
                        if (_selectedPropertyId == null) {
                          Get.snackbar('Property required', 'Please select a property for this entry');
                          return;
                        }

                        final amount = double.parse(_amountController.text.trim());

                        if (widget.ledgerId == null) {
                          ledgerController.addLedger(
                            title: _titleController.text.trim(),
                            amount: amount,
                            type: _type,
                            propertyId: _selectedPropertyId,
                            date: _selectedDate,
                            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                          );
                        } else {
                          final existing = ledgerController.getById(widget.ledgerId!);
                          if (existing != null) {
                            ledgerController.updateLedger(
                              existing.copyWith(
                                title: _titleController.text.trim(),
                                amount: amount,
                                type: _type,
                                propertyId: _selectedPropertyId,
                                date: _selectedDate,
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

