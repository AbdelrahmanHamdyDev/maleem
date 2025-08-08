import 'package:flutter/material.dart';
import 'package:maleem/Controller/hive.dart';
import 'package:maleem/Model/Expense.dart';
import 'package:maleem/Screen/FilterScreen.dart';
import 'package:maleem/app_text_styles.dart';

class ExpenseWidget extends StatelessWidget {
  ExpenseWidget({super.key, required this.ExpenseItem});

  final Expense ExpenseItem;
  final hiveController = HiveController();

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
            Text(ExpenseItem.title, style: AppTextStyles.expenseItemTitle),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  (is_Expense) ? "- $amount" : "+ $amount",
                  style: AppTextStyles.expenseItemInfo.copyWith(
                    color: (is_Expense) ? Colors.red : Colors.green,
                  ),
                ),
                if (filtred_groupExpenses.isNotEmpty)
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Filterscreen(
                          filteredItems: filtred_groupExpenses,
                          title: ExpenseItem.groupId!,
                        ),
                      ),
                    ),
                    child: Text(
                      ExpenseItem.groupId!,
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
