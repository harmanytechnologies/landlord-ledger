import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/property_controller.dart';
import '../../controllers/reminder_controller.dart';
import '../../helper/colors.dart';
import 'reminder_detail_view.dart';
import 'reminder_form_view.dart';

class ReminderListView extends StatefulWidget {
  static const routeName = '/reminders';

  const ReminderListView({Key? key}) : super(key: key);

  @override
  State<ReminderListView> createState() => _ReminderListViewState();
}

class _ReminderListViewState extends State<ReminderListView> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    final reminderController = Get.put(ReminderController());
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
          'Reminders',
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
          return _buildRemindersList(
            context,
            reminderController,
            propertyController,
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const ReminderFormView());
        },
        backgroundColor: kSecondaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Reminder',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildRemindersList(
    BuildContext context,
    ReminderController reminderController,
    PropertyController propertyController,
  ) {
    return Column(
      children: [
        // Professional Segmented Control Style Tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: kBackgroundVarientColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildTabButton(context, 'All', 0),
                _buildTabButton(context, 'Pending', 1),
                _buildTabButton(context, 'Completed', 2),
              ],
            ),
          ),
        ),
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
              placeholder: 'Search by title, type, or description',
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
        // Reminders List
        Expanded(
          child: _buildRemindersContent(
            context,
            reminderController,
            propertyController,
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(BuildContext context, String label, int index) {
    final isSelected = _currentTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentTabIndex = index;
            _tabController.animateTo(index);
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? kSecondaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: kSecondaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.white : kTextColor.withOpacity(0.7),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRemindersContent(
    BuildContext context,
    ReminderController reminderController,
    PropertyController propertyController,
  ) {
    // Apply tab filter
    List reminders = reminderController.reminders.toList();
    if (_currentTabIndex == 1) {
      reminders = reminderController.getPending();
    } else if (_currentTabIndex == 2) {
      reminders = reminderController.getCompleted();
    }

    // Apply search filter
    final query = _searchQuery.toLowerCase();
    final filteredReminders = reminders.where((r) {
      if (query.isEmpty) return true;
      final title = r.title.toLowerCase();
      final type = r.type.toLowerCase();
      final description = (r.description ?? '').toLowerCase();
      return title.contains(query) || type.contains(query) || description.contains(query);
    }).toList();

    if (filteredReminders.isEmpty) {
      return Center(
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
                  reminderController.reminders.isEmpty ? Icons.notifications_outlined : Icons.search_off,
                  size: 60,
                  color: kSecondaryColor,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                reminderController.reminders.isEmpty ? 'No Reminders' : 'No Results',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: kTextColor,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                reminderController.reminders.isEmpty
                    ? 'No reminders created yet.\nTap "Add Reminder" to get started.'
                    : 'No reminders match your search.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: kTextColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredReminders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final reminder = filteredReminders[index];
        final property = reminder.propertyId != null
            ? propertyController.getById(reminder.propertyId!)
            : null;
        final now = DateTime.now();
        final isPastDue = reminder.date.isBefore(now);

        return InkWell(
          onTap: () {
            Get.to(() => ReminderDetailView(reminderId: reminder.id));
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (reminder.isCompleted || isPastDue)
                        ? kGreenColor.withOpacity(0.12)
                        : kSecondaryColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    (reminder.isCompleted || isPastDue)
                        ? Icons.check_circle
                        : Icons.notifications_none,
                    color: (reminder.isCompleted || isPastDue)
                        ? kGreenColor
                        : kSecondaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: kTextColor,
                              decoration: reminder.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                      ),
                      const SizedBox(height: 4),
                      if (property != null)
                        Text(
                          property.title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: kTextColor.withOpacity(0.7),
                                fontSize: 13,
                              ),
                        ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: kTextColor.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${dateFormat.format(reminder.date)} at ${timeFormat.format(reminder.date)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: kTextColor.withOpacity(0.5),
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                      if (reminder.type.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            reminder.type,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isPastDue && !reminder.isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kGreenColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Completed',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: kGreenColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

}

