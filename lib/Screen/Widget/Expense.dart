import 'package:flutter/material.dart';
import 'package:maleem/Model/Expense.dart';
import 'package:maleem/app_text_styles.dart';

class ExpenseWidget extends StatelessWidget {
  const ExpenseWidget({super.key, required this.ExpenseItem});

  final Expense ExpenseItem;

  @override
  Widget build(BuildContext context) {
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
                if (ExpenseItem.groupId != null)
                  InkWell(
                    onTap: () =>
                        print("This is the GroupId: ${ExpenseItem.groupId}"),
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
