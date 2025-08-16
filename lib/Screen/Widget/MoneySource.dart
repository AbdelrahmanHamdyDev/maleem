import 'package:flutter/material.dart';
import 'package:maleem/Controller/hive.dart';
import 'package:maleem/Model/MoneySource.dart';
import 'package:maleem/Screen/FilterScreen.dart';
import 'package:maleem/Screen/SaveMoneySourceScreen.dart';
import 'package:maleem/app_text_styles.dart';

class MoneySourceWidget extends StatelessWidget {
  MoneySourceWidget({
    super.key,
    required this.onRefresh,
    required this.SourceItem,
  });

  final VoidCallback onRefresh;
  final MoneySource SourceItem;
  final hiveController = HiveController();

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
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Text(SourceItem.title, style: AppTextStyles.moneySourceTitle),
              ],
            ),
            const Spacer(),
            Text(
              SourceItem.amount.toStringAsFixed(2),
              style: AppTextStyles.moneySourceAmount,
            ),
          ],
        ),
      ),
    );
  }
}
