import 'package:flutter/material.dart';
import 'package:maleem/model/Expense.dart';
import 'package:maleem/screens/widgets/expenses_viewer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:maleem/screens/widgets/money_source_card.dart';
import 'package:maleem/core/app_text_styles.dart';
import 'package:maleem/core/hive_service.dart';
import 'package:maleem/screens/save_expense_screen.dart';
import 'package:maleem/screens/save_money_source_screen.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              //TotalBalaned
              Text.rich(
                TextSpan(
                  text: "Total balance: \$",
                  style: AppTextStyles.MainFont,
                  children: [
                    TextSpan(
                      text: hiveController
                          .getTotalMoneySourceAmount()
                          .toStringAsFixed(2),
                      style: AppTextStyles.Totalbalancedamount.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              //Money Source
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                child: Row(
                  children: [
                    Flexible(
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          dashPattern: [10, 5],
                          radius: const Radius.circular(20),
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        child: InkWell(
                          onTap: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const saveMoneySourceScreen(),
                              ),
                            );
                            if (result == true) {
                              setState(() {});
                            }
                          },
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Center(
                              child: Text(
                                "+ Add Card",
                                style: AppTextStyles.moneySourceAddButton,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 0.9),
                        itemCount: sourceBoxItems.length,
                        itemBuilder: (context, index) {
                          return MoneySourceWidget(
                            onRefresh: () => setState(() {}),
                            SourceItem: sourceBoxItems[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              //Expenses
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        top: 50,
                        bottom: 10,
                        left: 5,
                        right: 5,
                      ),
                      margin: const EdgeInsets.only(top: 30),
                      child: ExpensesViewer(
                        items: expensesBoxItems,
                        onRefresh: () => setState(() {}),
                        is_expenseGroupAppear: true,
                      ),
                    ),
                    Align(
                      alignment: AlignmentGeometry.topCenter,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        height: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final result = await Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SaveExpenseScreen(
                                                TransfareType:
                                                    ExpenseType.expense,
                                              ),
                                        ),
                                      );
                                  if (result == true) {
                                    setState(() {});
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 10,
                                  children: [
                                    const Icon(Icons.call_made),
                                    Text(
                                      "Transfer",
                                      style: AppTextStyles.AddTitle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            VerticalDivider(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final result = await Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SaveExpenseScreen(
                                                TransfareType:
                                                    ExpenseType.income,
                                              ),
                                        ),
                                      );
                                  if (result == true) {
                                    setState(() {});
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 10,
                                  children: [
                                    const Icon(Icons.call_received),
                                    Text(
                                      "Receive",
                                      style: AppTextStyles.AddTitle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
