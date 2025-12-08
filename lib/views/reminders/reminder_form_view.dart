import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/property_controller.dart';
import '../../controllers/reminder_controller.dart';
import '../../helper/colors.dart';
import '../../widgets/custom_text_form_field.dart';

class ReminderFormView extends StatefulWidget {
  static const routeName = '/reminders/form';

  final String? reminderId;
  final String? propertyId; // Optional: pre-fill property when adding from property details

  const ReminderFormView({Key? key, this.reminderId, this.propertyId}) : super(key: key);

  @override
  State<ReminderFormView> createState() => _ReminderFormViewState();
}

class _ReminderFormViewState extends State<ReminderFormView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedPropertyId;
  String _type = 'Task';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Reminder types
  final List<String> _types = [
    'Rent Due',
    'Inspection',
    'Task',
    'Maintenance',
    'Payment',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final reminderController = Get.find<ReminderController>();

    // Pre-fill property if provided
    if (widget.propertyId != null) {
      _selectedPropertyId = widget.propertyId;
    }

    if (widget.reminderId != null) {
      final reminder = reminderController.getById(widget.reminderId!);
      if (reminder != null) {
        _titleController.text = reminder.title;
        _descriptionController.text = reminder.description ?? '';
        _selectedPropertyId = reminder.propertyId ?? _selectedPropertyId;
        _type = reminder.type;
        // If editing, use reminder date/time, but ensure it's not in the past
        final reminderDateTime = reminder.date;
        final now = DateTime.now();
        if (reminderDateTime.isBefore(now)) {
          // If past, set to now + 1 hour
          _selectedDate = DateTime.now();
          _selectedTime = TimeOfDay.fromDateTime(now.add(const Duration(hours: 1)));
        } else {
          _selectedDate = reminderDateTime;
          _selectedTime = TimeOfDay.fromDateTime(reminderDateTime);
        }
      }
    } else {
      // For new reminders, set to now + 1 hour by default
      final now = DateTime.now();
      _selectedDate = now;
      _selectedTime = TimeOfDay.fromDateTime(now.add(const Duration(hours: 1)));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(today) ? today : _selectedDate,
      firstDate: today, // Only allow today or future dates
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
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        // If selected date is today, ensure time is in the future
        if (picked.year == today.year && picked.month == today.month && picked.day == today.day) {
          final currentTime = TimeOfDay.fromDateTime(now);
          if (_selectedTime.hour < currentTime.hour || 
              (_selectedTime.hour == currentTime.hour && _selectedTime.minute <= currentTime.minute)) {
            // Set to 1 hour from now if time is in the past
            _selectedTime = TimeOfDay.fromDateTime(now.add(const Duration(hours: 1)));
          }
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = _selectedDate.year == today.year && 
                    _selectedDate.month == today.month && 
                    _selectedDate.day == today.day;
    
    // If today, set initial time to current time or later
    TimeOfDay initialTime = _selectedTime;
    if (isToday) {
      final currentTime = TimeOfDay.fromDateTime(now);
      if (_selectedTime.hour < currentTime.hour || 
          (_selectedTime.hour == currentTime.hour && _selectedTime.minute <= currentTime.minute)) {
        initialTime = TimeOfDay.fromDateTime(now.add(const Duration(minutes: 1)));
      }
    }
    
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
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
    if (picked != null) {
      // Validate: if today, time must be in the future
      if (isToday) {
        final currentTime = TimeOfDay.fromDateTime(now);
        if (picked.hour < currentTime.hour || 
            (picked.hour == currentTime.hour && picked.minute <= currentTime.minute)) {
          Get.snackbar(
            'Invalid Time',
            'Please select a future time for today',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: kRedColor.withOpacity(0.9),
            colorText: Colors.white,
          );
          return;
        }
      }
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final reminderController = Get.put(ReminderController());
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
                          widget.reminderId == null ? 'Add Reminder' : 'Edit Reminder',
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
                          // Reminder Title
                          Text(
                            'Title',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          customTextFormField(
                            context,
                            hintText: 'e.g. Rent Due',
                            controller: _titleController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Type Dropdown
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
                                items: _types.map((type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  );
                                }).toList(),
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
                          // Property Dropdown (Optional)
                          Text(
                            'Property (Optional)',
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
                                hint: const Text('Select property (optional)'),
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text('None'),
                                  ),
                                  ...propertyController.properties.map((property) {
                                    return DropdownMenuItem<String>(
                                      value: property.id,
                                      child: Text(property.title),
                                    );
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPropertyId = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Date Picker
                          Text(
                            'Date',
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
                          // Time Picker
                          Text(
                            'Time',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () => _selectTime(context),
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
                                    _selectedTime.format(context),
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.access_time,
                                    size: 20,
                                    color: kTextColor.withOpacity(0.6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Description (Optional)
                          Text(
                            'Description (Optional)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          customTextFormField(
                            context,
                            hintText: 'Enter description',
                            controller: _descriptionController,
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

                        // Combine date and time
                        final dateTime = DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          _selectedTime.hour,
                          _selectedTime.minute,
                        );

                        // Validate that the date/time is not in the past
                        final now = DateTime.now();
                        if (dateTime.isBefore(now)) {
                          Get.snackbar(
                            'Invalid Date/Time',
                            'Please select a future date and time',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: kRedColor.withOpacity(0.9),
                            colorText: Colors.white,
                          );
                          return;
                        }

                        if (widget.reminderId == null) {
                          reminderController.addReminder(
                            title: _titleController.text.trim(),
                            description: _descriptionController.text.trim().isEmpty
                                ? null
                                : _descriptionController.text.trim(),
                            date: dateTime,
                            propertyId: _selectedPropertyId,
                            type: _type,
                          );
                        } else {
                          final existing = reminderController.getById(widget.reminderId!);
                          if (existing != null) {
                            reminderController.updateReminder(
                              existing.copyWith(
                                title: _titleController.text.trim(),
                                description: _descriptionController.text.trim().isEmpty
                                    ? null
                                    : _descriptionController.text.trim(),
                                date: dateTime,
                                propertyId: _selectedPropertyId,
                                type: _type,
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

