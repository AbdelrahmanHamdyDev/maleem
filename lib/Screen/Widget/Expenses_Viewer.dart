import 'package:flutter/material.dart';
import 'package:maleem/Controller/hive.dart';
import 'package:maleem/Model/Expense.dart';
import 'package:maleem/Screen/SaveExpenseScreen.dart';
import 'package:maleem/Screen/Widget/Expense.dart';

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
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onDismissed: (direction) {
          hiveController.deleteExpense(items[index]);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Successfuly deleted the Expense")),
          );
        },
        key: ValueKey(items[index]),
        child: InkWell(
          onLongPress: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SaveExpenseScreen(expense: items[index]),
              ),
            );
            if (result == true) {
              onRefresh();
            }
          },
          child: ExpenseWidget(
            ExpenseItem: items[index],
            is_groupAppear: is_expenseGroupAppear,
          ),
        ),
      ),
    );
  }
}
