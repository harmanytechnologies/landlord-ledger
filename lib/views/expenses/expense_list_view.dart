import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/expense_controller.dart';
import '../../controllers/property_controller.dart';
import '../../helper/colors.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';
import 'expense_detail_view.dart';
import 'expense_form_view.dart';

class ExpenseListView extends StatefulWidget {
  static const routeName = '/expenses';

  const ExpenseListView({Key? key}) : super(key: key);

  @override
  State<ExpenseListView> createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
    final expenseController = Get.put(ExpenseController());
    final propertyController = Get.find<PropertyController>();

    return Scaffold(
      appBar: CustomAppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 32,
              width: 32,
            ),
            const SizedBox(width: 8),
            Text(
              'Landlord Ledger',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
            ),
          ],
        ),
      ),
      body: Obx(
        () {
          if (expenseController.expenses.isEmpty) {
            return _buildEmptyState(context, expenseController);
          }

          return _buildExpensesList(
            context,
            expenseController,
            propertyController,
          );
        },
      ),
      floatingActionButton: Obx(
        () {
          if (expenseController.expenses.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () {
              Get.to(() => const ExpenseFormView());
            },
            backgroundColor: kSecondaryColor,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Expense',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ExpenseController expenseController) {
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
                Icons.receipt_long_outlined,
                size: 60,
                color: kSecondaryColor,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Expenses',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: kTextColor,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'No expenses yet.\nTap "Add Expense" to get started.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: kTextColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: customButton(
                onPressed: () {
                  Get.to(() => const ExpenseFormView());
                },
                child: const Text(
                  'Add Expense',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesList(BuildContext context, ExpenseController expenseController, PropertyController propertyController) {
    // Start with all expenses
    List expenses = expenseController.expenses.toList();

    // Apply tab filter
    if (_currentTabIndex == 1) {
      // Paid
      expenses = expenses.where((e) => e.isPaid).toList();
    } else if (_currentTabIndex == 2) {
      // Due
      expenses = expenses.where((e) => !e.isPaid).toList();
    }

    // Apply search filter (by anything: title, property, category, notes)
    final query = _searchQuery.toLowerCase();
    if (query.isNotEmpty) {
      expenses = expenses.where((e) {
        final title = e.title.toLowerCase();
        final category = e.category.toLowerCase();
        final notes = (e.notes ?? '').toLowerCase();
        final propertyTitle = e.propertyId != null ? (propertyController.getById(e.propertyId!)?.title.toLowerCase() ?? '') : '';
        return title.contains(query) || category.contains(query) || notes.contains(query) || propertyTitle.contains(query);
      }).toList();
    }

    return Column(
      children: [
        // Tabs: All, Paid, Due
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: kBackgroundVarientColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: kTextColor.withOpacity(0.7),
              indicator: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Paid'),
                Tab(text: 'Due'),
              ],
            ),
          ),
        ),
        // Search Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: kBackgroundVarientColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: CupertinoSearchTextField(
              controller: _searchController,
              placeholder: 'Search by title, property, category, or notes',
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
        const SizedBox(height: 8),
        // Expenses List
        Expanded(
          child: expenses.isEmpty
              ? Center(
                  child: Text(
                    'No expenses found',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kTextColor.withOpacity(0.6),
                        ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: expenses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    final property = expense.propertyId != null ? propertyController.getById(expense.propertyId!) : null;
                    return _buildExpenseCard(context, expense, property);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildExpenseCard(BuildContext context, expense, property) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return InkWell(
      onTap: () {
        Get.to(() => ExpenseDetailView(expenseId: expense.id));
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    expense.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: kTextColor,
                        ),
                  ),
                  const SizedBox(height: 6),
                  // Address (Property name)
                  if (property != null)
                    Text(
                      property.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: kTextColor.withOpacity(0.7),
                            fontSize: 13,
                          ),
                    ),
                  const SizedBox(height: 4),
                  // Due Date (light grey)
                  Text(
                    dateFormat.format(expense.date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: kTextColor.withOpacity(0.5),
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Amount (right side)
                Text(
                  currencyFormat.format(expense.amount),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: kTextColor,
                      ),
                ),
                const SizedBox(height: 6),
                // Status Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: expense.isPaid ? kGreenColor.withOpacity(0.15) : kRedColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    expense.isPaid ? 'Paid' : 'Due',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: expense.isPaid ? kGreenColor : kRedColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
