import 'package:flutter/material.dart';
import 'package:maleem/Model/MoneySource.dart';
import 'package:maleem/app_text_styles.dart';

class MoneySourceWidget extends StatelessWidget {
  const MoneySourceWidget({super.key, required this.SourceItem});

  final MoneySource SourceItem;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text(SourceItem.name, style: AppTextStyles.moneySourceTitle),
            ],
          ),
          const Spacer(),
          Text(
            SourceItem.amount.toStringAsFixed(2),
            style: AppTextStyles.moneySourceAmount,
          ),
        ],
      ),
    );
  }
}
