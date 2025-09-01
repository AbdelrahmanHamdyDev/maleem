import 'package:flutter/material.dart';
import 'package:maleem/model/Expense.dart';
import 'package:maleem/core/app_text_styles.dart';
import 'package:maleem/core/hive_service.dart';
import 'package:maleem/screens/filter_screen.dart';

class ExpenseWidget extends StatelessWidget {
  ExpenseWidget({
    super.key,
    required this.ExpenseItem,
    required this.is_groupAppear,
  });

  final Expense ExpenseItem;
  final bool is_groupAppear;
  final hiveController = HiveController();

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    String returnValue = "";

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          returnValue = "Just now";
        } else {
          returnValue = "Today";
        }
      }
    } else if (difference.inDays == 1) {
      returnValue = "Yesterday";
    } else {
      returnValue = "${difference.inDays} days ago";
    }
    int hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : (dateTime.hour == 0 ? 12 : dateTime.hour);
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String period = dateTime.hour >= 12 ? "PM" : "AM";

    return "$returnValue, $hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    List<Expense> filtred_groupExpenses = (ExpenseItem.groupId == null)
        ? []
        : hiveController.getExpensesByGroup(ExpenseItem.groupId!);

    final is_Expense = ExpenseItem.type.name == ExpenseType.expense.name;
    final amount = ExpenseItem.amount.toStringAsFixed(2);
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          spacing: 10,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ExpenseItem.title, style: AppTextStyles.expenseItemTitle),
                Text(
                  formatDateTime(ExpenseItem.date),
                  style: AppTextStyles.expenseItemdate,
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  (is_Expense) ? "- \$$amount" : "+ \$$amount",
                  style: AppTextStyles.expenseItemamount.copyWith(
                    color: (is_Expense) ? Colors.red : Colors.green,
                  ),
                ),
                if (filtred_groupExpenses.isNotEmpty && is_groupAppear)
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Filterscreen(
                          filteredItems: filtred_groupExpenses,
                          title: hiveController
                              .getGroupsName(excludeId: ExpenseItem.groupId!)
                              .first,
                          type: filterType.group,
                        ),
                      ),
                    ),
                    child: Text(
                      hiveController
                          .getGroupsName(excludeId: ExpenseItem.groupId!)
                          .first,
                      style: AppTextStyles.groupTitle,
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
