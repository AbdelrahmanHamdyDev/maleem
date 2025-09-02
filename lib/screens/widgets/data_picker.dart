import 'package:flutter/material.dart';
import 'package:maleem/core/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DatePickerRow extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onPickDate;

  const DatePickerRow({
    super.key,
    required this.selectedDate,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          selectedDate != null
              ? "Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
              : "No date chosen",
          style: AppTextStyles.MainFont.copyWith(fontSize: 18.sp),
        ),
        IconButton(onPressed: onPickDate, icon: const Icon(Icons.date_range)),
      ],
    );
  }
}
