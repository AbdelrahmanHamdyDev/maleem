import 'package:flutter/material.dart';
import 'package:maleem/Controller/hive.dart';
import 'package:maleem/Screen/Widget/Expense.dart';
import 'package:maleem/Screen/Widget/MoneySource.dart';

class Homescreen extends StatelessWidget {
  final hiveController = HiveController();

  @override
  Widget build(BuildContext context) {
    final sourceBoxItems = hiveController.getMoneySources();
    final expensesBoxItems = hiveController.getExpenses();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            spacing: 20,
            children: [
              //Money Source
              SizedBox(
                height: MediaQuery.of(context).size.height / 4.5,
                child: PageView.builder(
                  itemCount: sourceBoxItems.length,
                  itemBuilder: (context, index) =>
                      MoneySourceWidget(SourceItem: sourceBoxItems[index]),
                ),
              ),

              //Expenses
              Expanded(
                child: ListView.builder(
                  itemCount: expensesBoxItems.length,
                  itemBuilder: (context, index) =>
                      ExpenseWidget(ExpenseItem: expensesBoxItems[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
