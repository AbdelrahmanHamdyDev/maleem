import 'package:flutter/material.dart';
import 'package:maleem/model/Expense.dart';
import 'package:maleem/model/ExpenseGroup.dart';
import 'package:maleem/model/MoneySource.dart';
import 'package:maleem/screens/widgets/custom_textField.dart';
import 'package:maleem/screens/widgets/data_picker.dart';
import 'package:maleem/screens/widgets/form_scaffold.dart';
import 'package:maleem/core/app_text_styles.dart';
import 'package:maleem/core/hive_service.dart';
import 'package:maleem/screens/save_group_screen.dart';

class SaveExpenseScreen extends StatefulWidget {
  const SaveExpenseScreen({
    super.key,
    this.expense,
    required this.TransfareType,
  });

  final Expense? expense;
  final TransfareType;

  @override
  State<SaveExpenseScreen> createState() => _SaveExpenseScreenState();
}

class _SaveExpenseScreenState extends State<SaveExpenseScreen> {
  final HiveController hiveController = HiveController();
  List<MoneySource> allMoneySource = [];
  List<ExpenseGroup> allGroups = [];

  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  String? _selectedMoneySource;
  String? _selectedGroup;
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 4)),
    );
    if (picked != null) {
      final now = DateTime.now();
      final combined = DateTime(
        picked.year,
        picked.month,
        picked.day,
        now.hour,
        now.minute,
      );

      setState(() => _selectedDate = combined);
    }
  }

  void _saveExpense() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.expense == null) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please select a Date")));
        return;
      }
      hiveController.addExpense(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate!,
        sourceId: _selectedMoneySource!,
        groupId: _selectedGroup,
        type: widget.TransfareType,
      );
    } else {
      hiveController.updateExpense(
        expense: widget.expense!,
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        sourceId: _selectedMoneySource!,
        groupId: _selectedGroup,
        date: _selectedDate!,
        type: widget.TransfareType,
      );
    }

    Navigator.pop(context, true);
  }

  @override
  void initState() {
    if (widget.expense != null) {
      _titleController = TextEditingController(text: widget.expense!.title);
      _amountController = TextEditingController(
        text: widget.expense!.amount.toStringAsFixed(2),
      );
      _selectedMoneySource = widget.expense!.sourceId;
      _selectedGroup = widget.expense!.groupId;
      _selectedDate = widget.expense!.date;
    }
    allMoneySource = hiveController.getMoneySources();
    allGroups = hiveController.getGroups();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: (widget.expense == null) ? "New Expense" : "Update Expense",
      formKey: _formKey,
      onSave: _saveExpense,
      children: [
        CustomTextField(
          label: "Title",
          controller: _titleController,
          validator: (value) =>
              value == null || value.isEmpty ? 'Please enter a title' : null,
        ),
        CustomTextField(
          label: "Amount",
          controller: _amountController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter amount';
            if (double.tryParse(value) == null || double.parse(value) < 0) {
              return 'Enter a valid number';
            }
            return null;
          },
        ),
        DropdownButtonFormField<String>(
          initialValue: _selectedMoneySource,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "Select Money Source",
            labelStyle: AppTextStyles.MainFont.copyWith(fontSize: 12),
          ),
          items: allMoneySource
              .map(
                (source) => DropdownMenuItem(
                  value: source.id,
                  child: Text(source.title),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedMoneySource = value),
          validator: (value) => value == null || value.isEmpty
              ? 'Please select a money source'
              : null,
        ),
        DropdownButtonFormField<String>(
          initialValue: _selectedGroup,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "Select Group",
            labelStyle: AppTextStyles.MainFont.copyWith(fontSize: 12),
          ),
          items: [
            const DropdownMenuItem(child: Text("StandAlone")),
            ...allGroups.map(
              (group) =>
                  DropdownMenuItem(value: group.id, child: Text(group.title)),
            ),
            const DropdownMenuItem(
              value: "new_group",
              child: Text("+ Add New Group"),
            ),
          ],
          onChanged: (value) async {
            if (value == "new_group") {
              final result = await showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: const SaveGroupScreen(),
                  ),
                ),
              );

              if (result == true) {
                setState(() {
                  allGroups = hiveController.getGroups();
                  _selectedGroup = allGroups.last.id;
                });
              }
            } else {
              setState(() => _selectedGroup = value);
            }
          },
        ),
        DatePickerRow(selectedDate: _selectedDate, onPickDate: _pickDate),
      ],
    );
  }
}
