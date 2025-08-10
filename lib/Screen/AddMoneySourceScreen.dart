import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:maleem/Controller/hive.dart';
import 'package:maleem/Screen/Widget/custom_textField.dart';
import 'package:maleem/Screen/Widget/form_scaffold.dart';

class AddMoneySourceScreen extends StatefulWidget {
  const AddMoneySourceScreen({super.key});

  @override
  State<AddMoneySourceScreen> createState() => _AddMoneySourceScreenState();
}

class _AddMoneySourceScreenState extends State<AddMoneySourceScreen> {
  final HiveController hiveController = HiveController();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  Color selectedColor = Colors.black;

  void _pickColor() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) => setState(() => selectedColor = color),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _saveMoneySource() {
    if (_formKey.currentState!.validate()) {
      hiveController.addMoneySource(
        name: _nameController.text,
        amount: double.parse(_amountController.text),
        colorValue: selectedColor.toARGB32(),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: "New Money Source",
      formKey: _formKey,
      onSave: _saveMoneySource,
      children: [
        CustomTextField(
          label: "Name",
          controller: _nameController,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter name';
            if (hiveController.checkMoneySourceExist(value)) {
              return 'The name already exists';
            }
            return null;
          },
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Color:"),
            InkWell(
              onTap: _pickColor,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: selectedColor,
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.5),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
