import 'package:get/get.dart';

import '../views/expenses/expense_detail_view.dart';
import '../views/expenses/expense_form_view.dart';
import '../views/expenses/expense_list_view.dart';
import '../views/ledgers/ledger_detail_view.dart';
import '../views/ledgers/ledger_form_view.dart';
import '../views/properties/property_list_view.dart';
import '../views/reminders/reminder_detail_view.dart';
import '../views/reminders/reminder_form_view.dart';
import '../views/reminders/reminder_list_view.dart';
import '../views/tenants/tenant_list_view.dart';

class GetPageList {
  static final pages = <GetPage>[
    GetPage(
      name: PropertyListView.routeName,
      page: () => const PropertyListView(),
    ),
    GetPage(
      name: TenantListView.routeName,
      page: () => const TenantListView(),
    ),
    // Expense Routes
    GetPage(
      name: ExpenseListView.routeName,
      page: () => const ExpenseListView(),
    ),
    GetPage(
      name: ExpenseFormView.routeName,
      page: () => const ExpenseFormView(),
    ),
    GetPage(
      name: ExpenseDetailView.routeName,
      page: () => const ExpenseDetailView(expenseId: ''),
    ),
    // Ledger Routes
    GetPage(
      name: LedgerFormView.routeName,
      page: () => const LedgerFormView(),
    ),
    GetPage(
      name: LedgerDetailView.routeName,
      page: () => const LedgerDetailView(ledgerId: ''),
    ),
    // Reminder Routes
    GetPage(
      name: ReminderListView.routeName,
      page: () => const ReminderListView(),
    ),
    GetPage(
      name: ReminderFormView.routeName,
      page: () => const ReminderFormView(),
    ),
    GetPage(
      name: ReminderDetailView.routeName,
      page: () => const ReminderDetailView(reminderId: ''),
    ),
  ];
}
