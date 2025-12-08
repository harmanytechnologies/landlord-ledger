import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../helper/hive_keys.dart';
import '../helper/notification_util.dart';
import '../models/reminder.dart';

class ReminderController extends GetxController {
  static const String _boxKey = 'reminders';

  final RxList<Reminder> reminders = <Reminder>[].obs;

  late final Box _box;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box(HiveKeys.mainBox);
    _loadFromHive();
    // Reschedule all pending reminders on app start
    _rescheduleAllPendingReminders();
  }

  void _loadFromHive() {
    final list = _box.get(_boxKey);
    if (list is List) {
      reminders.assignAll(
        list.map((e) => Reminder.fromMap(e as Map<dynamic, dynamic>)).toList(),
      );
    }
  }

  void _saveToHive() {
    final list = reminders.map((r) => r.toMap()).toList();
    _box.put(_boxKey, list);
  }

  Reminder addReminder({
    required String title,
    String? description,
    required DateTime date,
    String? propertyId,
    required String type,
    bool isCompleted = false,
  }) {
    final reminder = Reminder(
      id: const Uuid().v4(),
      title: title,
      description: description,
      date: date,
      propertyId: propertyId,
      type: type,
      isCompleted: isCompleted,
    );
    reminders.add(reminder);
    _saveToHive();
    
    // Schedule notification if not completed and date is in the future
    if (!isCompleted && !isPastDue(reminder)) {
      _scheduleNotification(reminder);
    }
    
    return reminder;
  }

  void updateReminder(Reminder updated) {
    final index = reminders.indexWhere((r) => r.id == updated.id);
    if (index != -1) {
      final oldReminder = reminders[index];
      reminders[index] = updated;
      _saveToHive();
      
      // Cancel old notification
      _cancelNotification(oldReminder);
      
      // Schedule new notification if not completed and date is in the future
      if (!updated.isCompleted && !isPastDue(updated)) {
        _scheduleNotification(updated);
      }
    }
  }

  void deleteReminder(Reminder reminder) {
    reminders.removeWhere((r) => r.id == reminder.id);
    _saveToHive();
    
    // Cancel notification
    _cancelNotification(reminder);
  }

  Reminder? getById(String id) {
    try {
      return reminders.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Reminder> getByPropertyId(String propertyId) {
    return reminders.where((r) => r.propertyId == propertyId).toList();
  }

  List<Reminder> getByType(String type) {
    return reminders.where((r) => r.type.toLowerCase() == type.toLowerCase()).toList();
  }

  // Check if a reminder is past its date/time
  bool isPastDue(Reminder reminder) {
    final now = DateTime.now();
    return reminder.date.isBefore(now);
  }

  // Check if a reminder should be considered completed
  // (either explicitly marked as completed OR past its date/time)
  bool isEffectivelyCompleted(Reminder reminder) {
    return reminder.isCompleted || isPastDue(reminder);
  }

  List<Reminder> getCompleted() {
    final now = DateTime.now();
    // Include reminders that are explicitly completed OR past their date/time
    return reminders.where((r) => r.isCompleted || r.date.isBefore(now)).toList();
  }

  List<Reminder> getPending() {
    final now = DateTime.now();
    // Include reminders that are not completed AND not past their date/time
    return reminders.where((r) => !r.isCompleted && (r.date.isAfter(now) || r.date.isAtSameMomentAs(now))).toList();
  }

  List<Reminder> getUpcoming() {
    final now = DateTime.now();
    return reminders.where((r) => !r.isCompleted && r.date.isAfter(now)).toList();
  }

  /// Schedule a notification for a reminder
  void _scheduleNotification(Reminder reminder) {
    final notificationId = NotificationUtil.getNotificationId(reminder.id);
    final body = reminder.description?.isNotEmpty == true
        ? reminder.description!
        : 'Reminder: ${reminder.type}';

    NotificationUtil.scheduleReminderNotification(
      id: notificationId,
      title: reminder.title,
      body: body,
      scheduledDate: reminder.date,
      payload: reminder.id, // Simple payload for navigation
    );
  }

  /// Cancel a notification for a reminder
  void _cancelNotification(Reminder reminder) {
    final notificationId = NotificationUtil.getNotificationId(reminder.id);
    NotificationUtil.cancelReminderNotification(notificationId);
  }

  /// Reschedule all pending reminders (called on app start)
  void _rescheduleAllPendingReminders() {
    final pending = getPending();
    for (final reminder in pending) {
      _scheduleNotification(reminder);
    }
  }
}

