import 'package:flutter/material.dart';
import 'package:maleem/core/ui_helper.dart';
import 'package:maleem/model/MoneySource.dart';
import 'package:maleem/core/app_text_styles.dart';
import 'package:maleem/screens/filter_screen.dart';
import 'package:maleem/screens/save_money_source_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoneySourceWidget extends StatelessWidget {
  MoneySourceWidget({
    super.key,
    required this.onRefresh,
    required this.SourceItem,
  });

  final VoidCallback onRefresh;
  final MoneySource SourceItem;

  @override
  Widget build(BuildContext context) {
    final filtred_sourceExpenses = hiveController.getExpensesByMoneySource(
      SourceItem.id,
    );

    return InkWell(
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Filterscreen(
              filteredItems: filtred_sourceExpenses,
              title: hiveController
                  .getMoneySourceName(excludeId: SourceItem.id)
                  .first,
              type: filterType.source,
            ),
          ),
        );
        if (result) {
          onRefresh();
        }
      },
      onLongPress: () async {
        final source = hiveController.getMoneySources().firstWhere(
          (s) => s.id == SourceItem.id,
        );
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => saveMoneySourceScreen(source: source),
          ),
        );
        if (result == true) {
          onRefresh();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(SourceItem.colorValue),
          border: Border.all(
            width: 2.w,
            color: UIHelper.getContrastingTextColor(SourceItem.colorValue),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        margin: EdgeInsets.only(right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              SourceItem.title,
              style: AppTextStyles.moneySourceTitle.copyWith(
                color: UIHelper.getContrastingTextColor(SourceItem.colorValue),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Text(
                "\$ ${SourceItem.amount.toStringAsFixed(2)}",
                style: AppTextStyles.moneySourceAmount.copyWith(
                  color: UIHelper.getContrastingTextColor(
                    SourceItem.colorValue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
