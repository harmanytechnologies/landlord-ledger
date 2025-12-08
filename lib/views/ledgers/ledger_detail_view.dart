import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/ledger_controller.dart';
import '../../controllers/property_controller.dart';
import '../../helper/colors.dart';
import 'ledger_form_view.dart';

class LedgerDetailView extends StatelessWidget {
  static const routeName = '/ledgers/detail';

  final String ledgerId;

  const LedgerDetailView({Key? key, required this.ledgerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ledgerController = Get.put(LedgerController());
    final propertyController = Get.find<PropertyController>();
    final ledger = ledgerController.getById(ledgerId);
    final dateFormat = DateFormat('MMM dd, yyyy');
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    if (ledger == null) {
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
          title: const Text('Ledger Entry'),
        ),
        body: const Center(
          child: Text('Ledger entry not found'),
        ),
      );
    }

    final property = ledger.propertyId != null ? propertyController.getById(ledger.propertyId!) : null;
    final isIncome = ledger.type.toLowerCase() == 'income';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: kTextColor),
            onPressed: () {
              Get.to(() => LedgerFormView(ledgerId: ledger.id));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: kRedColor),
            onPressed: () {
              _showDeleteConfirmation(context, ledgerController, ledger);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    ledger.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: kTextColor,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isIncome ? kGreenColor.withOpacity(0.15) : kRedColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    ledger.type,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isIncome ? kGreenColor : kRedColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              currencyFormat.format(ledger.amount),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: kTextColor,
                  ),
            ),
            const SizedBox(height: 24),
            _infoRow(
              context,
              label: 'Property',
              value: property?.title ?? 'N/A',
              icon: Icons.home_outlined,
            ),
            const SizedBox(height: 12),
            _infoRow(
              context,
              label: 'Date',
              value: dateFormat.format(ledger.date),
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 12),
            _infoRow(
              context,
              label: 'Type',
              value: ledger.type,
              icon: isIncome ? Icons.trending_up : Icons.trending_down,
              valueColor: isIncome ? kGreenColor : kRedColor,
            ),
            const SizedBox(height: 24),
            if (ledger.notes != null && ledger.notes!.trim().isNotEmpty) ...[
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: kTextColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                ledger.notes!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: kTextColor.withOpacity(0.8),
                      height: 1.6,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, {required String label, required String value, IconData? icon, Color? valueColor}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: kTextColor.withOpacity(0.6), size: 20),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: kTextColor.withOpacity(0.6),
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: valueColor ?? kTextColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, LedgerController controller, ledger) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Entry',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete "${ledger.title}"? This action cannot be undone.',
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
                controller.deleteLedger(ledger);
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

