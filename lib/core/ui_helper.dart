import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:maleem/core/app_text_styles.dart';
import 'package:maleem/core/hive_service.dart';
import 'package:maleem/model/Expense.dart';

final hiveController = HiveController();

class UIHelper {
  /// Pick a color dialog
  static Future<Color?> pickColor({
    required BuildContext context,
    required Color initialColor,
  }) async {
    Color selectedColor = initialColor;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Pick a color', style: AppTextStyles.MainFont),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) => selectedColor = color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Done', style: AppTextStyles.MainFont),
          ),
        ],
      ),
    );

    return selectedColor;
  }

  /// Save money source (add / update)
  static void saveMoneySource({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
    required HiveController hiveController,
    required TextEditingController titleController,
    required TextEditingController amountController,
    required Color selectedColor,
    dynamic source,
  }) {
    if (!formKey.currentState!.validate()) return;

    if (source == null) {
      hiveController.addMoneySource(
        title: titleController.text,
        amount: double.parse(amountController.text),
        colorValue: selectedColor.toARGB32(),
      );
    } else {
      hiveController.updateMoneySource(
        source: source,
        title: titleController.text,
        amount: double.parse(amountController.text),
        colorValue: selectedColor.toARGB32(),
      );
    }

    Navigator.pop(context, true);
  }

  /// Save group (add / update)
  static void saveGroup({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
    required HiveController hiveController,
    required TextEditingController titleController,
    required TextEditingController noteController,
    dynamic group,
  }) {
    if (!formKey.currentState!.validate()) return;

    if (group == null) {
      hiveController.addGroup(
        title: titleController.text,
        note: noteController.text,
      );
    } else {
      hiveController.updateGroup(
        group: group,
        title: titleController.text,
        note: noteController.text,
      );
    }

    Navigator.pop(context, true);
  }

  /// Pick a date
  static Future<DateTime?> pickDate({
    required BuildContext context,
    DateTime? initialDate,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 4)),
    );

    if (picked == null) return null;

    final now = DateTime.now();
    return DateTime(
      picked.year,
      picked.month,
      picked.day,
      now.hour,
      now.minute,
    );
  }

  /// Save expense (add / update)
  static void saveExpense({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
    required HiveController hiveController,
    required TextEditingController titleController,
    required TextEditingController amountController,
    required DateTime? selectedDate,
    required String selectedMoneySource,
    required String? selectedGroup,
    required ExpenseType transferType,
    dynamic expense,
  }) {
    if (!formKey.currentState!.validate()) return;

    if (expense == null) {
      if (selectedDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please select a Date")));
        return;
      }

      hiveController.addExpense(
        title: titleController.text,
        amount: double.parse(amountController.text),
        date: selectedDate,
        sourceId: selectedMoneySource,
        groupId: selectedGroup,
        type: transferType,
      );
    } else {
      hiveController.updateExpense(
        expense: expense,
        title: titleController.text,
        amount: double.parse(amountController.text),
        date: selectedDate!,
        sourceId: selectedMoneySource,
        groupId: selectedGroup,
        type: transferType,
      );
    }

    Navigator.pop(context, true);
  }

  /// Format a DateTime into "Today, 5:30 PM".
  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    String returnValue = "";

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          returnValue = "Just now";
        } else {
          returnValue = "Today";
        }
      }
    } else if (difference.inDays == 1) {
      returnValue = "Yesterday";
    } else {
      returnValue = "${difference.inDays} days ago";
    }

    int hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : (dateTime.hour == 0 ? 12 : dateTime.hour);
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String period = dateTime.hour >= 12 ? "PM" : "AM";

    return "$returnValue, $hour:$minute $period";
  }

  /// Get contrasting text color
  static Color getContrastingTextColor(int colorValue) {
    final c = Color(colorValue);
    // Black = 0 , White = 1
    return c.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
