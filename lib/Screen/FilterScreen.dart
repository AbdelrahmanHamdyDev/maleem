import 'package:flutter/material.dart';
import 'package:maleem/Model/Expense.dart';
import 'package:maleem/Screen/Widget/Expenses_Viewer.dart';

class Filterscreen extends StatelessWidget {
  const Filterscreen({
    super.key,
    required this.title,
    required this.filteredItems,
  });

  final List<Expense> filteredItems;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            Navigator.pop(context, true);
          }
        },
        child: (filteredItems.isEmpty)
            ? const Center(child: Text("No Expenses Found"))
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: ExpensesViewer(items: filteredItems),
              ),
      ),
    );
  }
}
