import 'package:flutter/material.dart';
import 'package:maleem/Controller/hive.dart';
import 'package:maleem/Screen/AddExpenseScreen.dart';
import 'package:maleem/Screen/AddGroupScreen.dart';
import 'package:maleem/Screen/AddMoneySourceScreen.dart';
import 'package:maleem/Screen/Widget/Expenses_Viewer.dart';
import 'package:maleem/Screen/Widget/MoneySource.dart';
import 'package:maleem/app_text_styles.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Homescreen extends StatefulWidget {
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final hiveController = HiveController();

  @override
  Widget build(BuildContext context) {
    final sourceBoxItems = hiveController.getMoneySources();
    final expensesBoxItems = hiveController.getExpenses();
    return Scaffold(
      floatingActionButton: (sourceBoxItems.isEmpty)
          ? null
          : SpeedDial(
              icon: Icons.add,
              activeIcon: Icons.close,
              backgroundColor: Colors.amber,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.group_add, color: Colors.white),
                  backgroundColor: Colors.red,
                  label: 'Add Group',
                  onTap: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddGroupScreen(),
                      ),
                    );
                    if (result == true) {
                      setState(() {});
                    }
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.money, color: Colors.white),
                  backgroundColor: Colors.green,
                  label: 'Add Transaction',
                  onTap: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddExpenseScreen(),
                      ),
                    );
                    if (result == true) {
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
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
                  itemCount: sourceBoxItems.length + 1,
                  itemBuilder: (context, index) {
                    if (index < sourceBoxItems.length)
                      return MoneySourceWidget(
                        onRefresh: () => setState(() {}),
                        SourceItem: sourceBoxItems[index],
                      );
                    else {
                      return InkWell(
                        onTap: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AddMoneySourceScreen(),
                            ),
                          );
                          if (result == true) {
                            setState(() {});
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.3),
                                blurRadius: 100,
                                blurStyle: BlurStyle.inner,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "+",
                              style: AppTextStyles.moneySourceTitle,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),

              //Expenses
              Expanded(child: ExpensesViewer(items: expensesBoxItems)),
            ],
          ),
        ),
      ),
    );
  }
}
