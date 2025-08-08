import 'package:flutter/material.dart';
import 'package:maleem/Controller/hive.dart';
import 'package:maleem/Model/Expense.dart';
import 'package:maleem/Screen/Widget/Expense.dart';

class ExpensesViewer extends StatelessWidget {
  ExpensesViewer({super.key, required this.items});

  final List<Expense> items;
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
          hiveController.deleteExpense(items[index].id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Successfuly deleted the Expense")),
          );
        },
        key: ValueKey(items[index]),
        child: ExpenseWidget(ExpenseItem: items[index]),
      ),
    );
  }
}
