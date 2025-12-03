import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/expense_controller.dart';
import '../../controllers/property_controller.dart';
import '../../helper/colors.dart';
import 'expense_form_view.dart';

class ExpenseDetailView extends StatefulWidget {
  static const routeName = '/expenses/detail';

  final String expenseId;

  const ExpenseDetailView({Key? key, required this.expenseId}) : super(key: key);

  @override
  State<ExpenseDetailView> createState() => _ExpenseDetailViewState();
}

class _ExpenseDetailViewState extends State<ExpenseDetailView> {
  @override
  Widget build(BuildContext context) {
    final expenseController = Get.put(ExpenseController());
    final propertyController = Get.find<PropertyController>();
    final expense = expenseController.getById(widget.expenseId);

    if (expense == null) {
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
          child: Text('Expense not found'),
        ),
      );
    }

    final property = expense.propertyId != null ? propertyController.getById(expense.propertyId!) : null;
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
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
                  'Expense Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                        fontSize: 34,
                      ),
                ),
              ),
            ),
            // Expense Information
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    expense.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: kTextColor,
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Amount
                  Text(
                    currencyFormat.format(expense.amount),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: kSecondaryColor,
                        ),
                  ),
                  const SizedBox(height: 24),
                  // Property
                  if (property != null) ...[
                    _buildInfoRow(context, Icons.home_outlined, 'Property', property.title),
                    const SizedBox(height: 16),
                  ],
                  // Category
                  _buildInfoRow(context, Icons.category_outlined, 'Category', expense.category),
                  const SizedBox(height: 16),
                  // Due Date
                  _buildInfoRow(
                    context,
                    Icons.calendar_today_outlined,
                    'Due Date',
                    dateFormat.format(expense.date),
                  ),
                  const SizedBox(height: 16),
                  // Status (Paid / Due) - user friendly
                  Text(
                    'Status',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kTextColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: expense.isPaid
                              ? kGreenColor.withOpacity(0.15)
                              : kRedColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: expense.isPaid ? kGreenColor : kRedColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              expense.isPaid ? 'Paid' : 'Due',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: expense.isPaid ? kGreenColor : kRedColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          final updated = expense.copyWith(isPaid: !expense.isPaid);
                          expenseController.updateExpense(updated);
                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          expense.isPaid ? 'Mark as Due' : 'Mark as Paid',
                          style: TextStyle(
                            color: kSecondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Notes
                  if (expense.notes != null && expense.notes!.trim().isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Notes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      expense.notes!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: kTextColor,
                            fontSize: 14,
                            height: 1.6,
                          ),
                    ),
                  ],
                  // Receipt
                  if (expense.receiptPath != null && expense.receiptPath!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Receipt',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(expense.receiptPath!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
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
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.to(() => ExpenseFormView(expenseId: expense.id));
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: kSecondaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Edit Expense',
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
                    _showDeleteConfirmation(context, expense, expenseController);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kRedColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Delete Expense',
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

  void _showDeleteConfirmation(BuildContext context, expense, ExpenseController expenseController) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Expense',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete "${expense.title}"? This action cannot be undone.',
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
                expenseController.deleteExpense(expense);
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
