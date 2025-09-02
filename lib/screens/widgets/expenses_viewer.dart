import 'package:flutter/material.dart';
import 'package:maleem/model/Expense.dart';
import 'package:maleem/screens/widgets/expense_item.dart';
import 'package:maleem/core/hive_service.dart';
import 'package:maleem/screens/save_expense_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpensesViewer extends StatelessWidget {
  ExpensesViewer({
    super.key,
    required this.items,
    required this.onRefresh,
    required this.is_expenseGroupAppear,
  });

  final List<Expense> items;
  final Function() onRefresh;
  final bool is_expenseGroupAppear;
  final hiveController = HiveController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Dismissible(
        background: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        onDismissed: (direction) async {
          await hiveController.deleteExpense(items[index]);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Successfuly deleted the Expense")),
          );
          onRefresh();
        },
        key: ValueKey(items[index].id),
        child: InkWell(
          onLongPress: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SaveExpenseScreen(
                  expense: items[index],
                  TransfareType: items[index].type,
                ),
              ),
            );
            if (result == true) {
              onRefresh();
            }
          },
          child: ExpenseWidget(
            expenseItem: items[index],
            is_groupAppear: is_expenseGroupAppear,
          ),
        ),
      ),
    );
  }
}
