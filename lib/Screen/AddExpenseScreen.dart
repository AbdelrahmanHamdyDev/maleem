import 'package:flutter/material.dart';
import 'package:maleem/Controller/hive.dart';
import 'package:maleem/Model/Expense.dart';
import 'package:maleem/Screen/Widget/custom_textField.dart';
import 'package:maleem/Screen/Widget/data_picker.dart';
import 'package:maleem/Screen/Widget/form_scaffold.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final HiveController hiveController = HiveController();
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

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
    if (_formKey.currentState!.validate()) {
      hiveController.addExpense(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate!,
        sourceId: _selectedMoneySource!,
        groupId: _selectedGroup!,
        type: _selectedType,
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: "New Expense",
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
          items: hiveController
              .getMoneySourceName()
              .map((name) => DropdownMenuItem(value: name, child: Text(name)))
              .toList(),
          onChanged: (value) => setState(() => _selectedMoneySource = value),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: _selectedGroup,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Select Group",
          ),
          items: ["StandAlone", ...hiveController.getGroupsName()]
              .map((name) => DropdownMenuItem(value: name, child: Text(name)))
              .toList(),
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
