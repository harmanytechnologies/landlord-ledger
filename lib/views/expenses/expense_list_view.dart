import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/expense_controller.dart';
import '../../controllers/property_controller.dart';
import '../../helper/colors.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';
import 'expense_detail_view.dart';
import 'expense_form_view.dart';

class ExpenseListView extends StatelessWidget {
  static const routeName = '/expenses';

  const ExpenseListView({Key? key}) : super(key: key);

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

          return _buildExpensesList(context, expenseController, propertyController);
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
                color: kPrimaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 60,
                color: kPrimaryColor,
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
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: expenseController.expenses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final expense = expenseController.expenses[index];
        final property = expense.propertyId != null ? propertyController.getById(expense.propertyId!) : null;
        return _buildExpenseCard(context, expense, property);
      },
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
                  // Date (light grey)
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
            // Amount (right side)
            Text(
              currencyFormat.format(expense.amount),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: kTextColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
