import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/property_controller.dart';
import '../../controllers/reminder_controller.dart';
import '../../helper/colors.dart';
import 'reminder_form_view.dart';

class ReminderDetailView extends StatefulWidget {
  static const routeName = '/reminders/detail';

  final String reminderId;

  const ReminderDetailView({Key? key, required this.reminderId}) : super(key: key);

  @override
  State<ReminderDetailView> createState() => _ReminderDetailViewState();
}

class _ReminderDetailViewState extends State<ReminderDetailView> {
  @override
  Widget build(BuildContext context) {
    final reminderController = Get.put(ReminderController());
    final propertyController = Get.find<PropertyController>();
    final reminder = reminderController.getById(widget.reminderId);

    if (reminder == null) {
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
          child: Text('Reminder not found'),
        ),
      );
    }

    final property = reminder.propertyId != null ? propertyController.getById(reminder.propertyId!) : null;
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('h:mm a');
    final isOverdue = !reminder.isCompleted && reminder.date.isBefore(DateTime.now());

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
            // Large Title Section
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reminder Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                        fontSize: 34,
                      ),
                ),
              ),
            ),
            // Reminder Information
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    reminder.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: kTextColor,
                          decoration: reminder.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                  ),
                  const SizedBox(height: 24),
                  // Status (Completed / Pending / Overdue) - user friendly
                  Text(
                    'Status',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kTextColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (reminder.isCompleted || isOverdue)
                          ? kGreenColor.withOpacity(0.15)
                          : kSecondaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: (reminder.isCompleted || isOverdue)
                                ? kGreenColor
                                : kSecondaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          (reminder.isCompleted || isOverdue)
                              ? 'Completed'
                              : 'Pending',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: (reminder.isCompleted || isOverdue)
                                    ? kGreenColor
                                    : kSecondaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Type
                  _buildInfoRow(context, Icons.label_outline, 'Type', reminder.type),
                  const SizedBox(height: 16),
                  // Date
                  _buildInfoRow(
                    context,
                    Icons.calendar_today_outlined,
                    'Date',
                    dateFormat.format(reminder.date),
                  ),
                  const SizedBox(height: 16),
                  // Time
                  _buildInfoRow(
                    context,
                    Icons.access_time,
                    'Time',
                    timeFormat.format(reminder.date),
                  ),
                  const SizedBox(height: 16),
                  // Property
                  if (property != null) ...[
                    _buildInfoRow(context, Icons.home_outlined, 'Property', property.title),
                    const SizedBox(height: 16),
                  ],
                  // Description
                  if (reminder.description != null && reminder.description!.trim().isNotEmpty) ...[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      reminder.description!,
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
      bottomNavigationBar: Container(
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
          child: (reminder.isCompleted || isOverdue)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Completed reminders cannot be edited or deleted',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kTextColor.withOpacity(0.6),
                          fontSize: 14,
                        ),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.to(() => ReminderFormView(reminderId: reminder.id));
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: kSecondaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Edit Reminder',
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
                          _showDeleteConfirmation(context, reminder, reminderController);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kRedColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Delete Reminder',
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

  void _showDeleteConfirmation(BuildContext context, reminder, ReminderController reminderController) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Reminder',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete "${reminder.title}"? This action cannot be undone.',
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
                reminderController.deleteReminder(reminder);
                Navigator.of(context).pop();
                Get.back();
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

