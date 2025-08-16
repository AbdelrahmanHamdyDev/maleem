import 'package:flutter/material.dart';
import 'package:maleem/Controller/hive.dart';
import 'package:maleem/Model/Expense.dart';
import 'package:maleem/Model/ExpenseGroup.dart';
import 'package:maleem/Model/MoneySource.dart';
import 'package:maleem/Screen/Widget/custom_textField.dart';
import 'package:maleem/Screen/Widget/data_picker.dart';
import 'package:maleem/Screen/Widget/form_scaffold.dart';

class SaveExpenseScreen extends StatefulWidget {
  const SaveExpenseScreen({super.key, this.expense});

  final Expense? expense;

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
  ExpenseType _selectedType = ExpenseType.expense;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 4)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
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
        type: _selectedType,
      );
    } else {
      hiveController.updateExpense(
        expense: widget.expense!,
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        sourceId: _selectedMoneySource!,
        groupId: _selectedGroup,
        date: _selectedDate!,
        type: _selectedType,
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
      _selectedType = widget.expense!.type;
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
        const SizedBox(height: 20),
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
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: _selectedMoneySource,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Select Money Source",
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
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: _selectedGroup,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Select Group",
          ),
          items: [
            const DropdownMenuItem(value: null, child: Text("StandAlone")),
            ...allGroups.map(
              (group) =>
                  DropdownMenuItem(value: group.id, child: Text(group.title)),
            ),
          ],
          onChanged: (value) => setState(() => _selectedGroup = value),
        ),
        const SizedBox(height: 20),
        DatePickerRow(selectedDate: _selectedDate, onPickDate: _pickDate),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: const Text("Expense"),
                value: ExpenseType.expense,
                groupValue: _selectedType,
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: const Text("Income"),
                value: ExpenseType.income,
                groupValue: _selectedType,
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
