import 'package:flutter/material.dart';

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
        ),
        IconButton(onPressed: onPickDate, icon: const Icon(Icons.date_range)),
      ],
    );
  }
}
