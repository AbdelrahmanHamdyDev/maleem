import 'package:flutter/material.dart';
import 'package:maleem/core/ui_helper.dart';
import 'package:maleem/model/Expense.dart';
import 'package:maleem/core/app_text_styles.dart';
import 'package:maleem/screens/filter_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseWidget extends StatelessWidget {
  ExpenseWidget({
    super.key,
    required this.expenseItem,
    required this.is_groupAppear,
  });

  final Expense expenseItem;
  final bool is_groupAppear;

  @override
  Widget build(BuildContext context) {
    List<Expense> filtred_groupExpenses = (expenseItem.groupId == null)
        ? []
        : hiveController.getExpensesByGroup(expenseItem.groupId!);

    final is_Expense = expenseItem.type.name == ExpenseType.expense.name;
    final amount = expenseItem.amount.toStringAsFixed(2);
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          spacing: 10.w,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expenseItem.title, style: AppTextStyles.expenseItemTitle),
                Text(
                  UIHelper.formatDateTime(expenseItem.date),
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
                              .getGroupsName(excludeId: expenseItem.groupId!)
                              .first,
                          type: filterType.group,
                        ),
                      ),
                    ),
                    child: Text(
                      hiveController
                          .getGroupsName(excludeId: expenseItem.groupId!)
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
