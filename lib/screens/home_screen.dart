import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:maleem/model/Expense.dart';
import 'package:maleem/model/MoneySource.dart';
import 'package:maleem/screens/widgets/expenses_viewer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:maleem/screens/widgets/money_source_card.dart';
import 'package:maleem/core/app_text_styles.dart';
import 'package:maleem/core/hive_service.dart';
import 'package:maleem/screens/save_expense_screen.dart';
import 'package:maleem/screens/save_money_source_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class Homescreen extends StatefulWidget {
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final hiveController = HiveController();

  // HomeWidget stuff
  final String appGroupId = "group.maleemApp";
  final String androidWidgetName = "MaleemWidget";
  final String dataKey = "text_from_flutter_app";

  late List<MoneySource> sourceBoxItems;
  late List<Expense> expensesBoxItems;
  late double totalBalance;
  bool _isLoading = true;

  Future<void> _updateWidgetBalance(double totalBalance) async {
    //save HomeWidget
    await HomeWidget.saveWidgetData(dataKey, totalBalance.toStringAsFixed(2));

    //update HomeWidget
    await HomeWidget.updateWidget(androidName: androidWidgetName);
  }

  Future<void> _loadData() async {
    _isLoading = true;
    sourceBoxItems = hiveController.getMoneySources();
    expensesBoxItems = hiveController.getExpenses();
    totalBalance = hiveController.getTotalMoneySourceAmount();

    await _updateWidgetBalance(totalBalance);
  }

  Future<void> _initializeApp() async {
    // Initialize HomeWidget
    await HomeWidget.setAppGroupId(appGroupId);

    await _loadData();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: Lottie.asset('assets/logo_animation.json')),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20.h,
            children: [
              //TotalBalaned
              Text.rich(
                TextSpan(
                  text: "Total balance: \$",
                  style: AppTextStyles.MainFont,
                  children: [
                    TextSpan(
                      text: totalBalance.toStringAsFixed(2),
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
                          radius: Radius.circular(20.r),
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
                              _refreshData();
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
                            onRefresh: () => _refreshData(),
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
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      padding: EdgeInsets.only(
                        top: 50.h,
                        bottom: 10.h,
                        left: 5.w,
                        right: 5.w,
                      ),
                      margin: EdgeInsets.only(top: 30.h),
                      child: ExpensesViewer(
                        items: expensesBoxItems,
                        onRefresh: () => _refreshData(),
                        is_expenseGroupAppear: true,
                      ),
                    ),
                    Align(
                      alignment: AlignmentGeometry.topCenter,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30.w),
                        height: 70.h,
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
                                    _refreshData();
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 10.h,
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
                                    _refreshData();
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 10.h,
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
