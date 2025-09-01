import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:maleem/model/MoneySource.dart';
import 'package:maleem/screens/widgets/custom_textField.dart';
import 'package:maleem/screens/widgets/form_scaffold.dart';
import 'package:maleem/core/app_text_styles.dart';
import 'package:maleem/core/hive_service.dart';

class saveMoneySourceScreen extends StatefulWidget {
  const saveMoneySourceScreen({super.key, this.source});

  final MoneySource? source;

  @override
  State<saveMoneySourceScreen> createState() => _saveMoneySourceScreenState();
}

class _saveMoneySourceScreenState extends State<saveMoneySourceScreen> {
  final HiveController hiveController = HiveController();
  List<String> SourceNames = [];
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  Color selectedColor = Colors.white;

  void _pickColor() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Pick a color', style: AppTextStyles.MainFont),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) => setState(() => selectedColor = color),
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
  }

  void _saveMoneySource() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.source == null) {
      hiveController.addMoneySource(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        colorValue: selectedColor.toARGB32(),
      );
    } else {
      hiveController.updateMoneySource(
        source: widget.source!,
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        colorValue: selectedColor.toARGB32(),
      );
    }
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    SourceNames = hiveController.getMoneySourceName();
    if (widget.source != null) {
      _titleController = TextEditingController(text: widget.source!.title);
      _amountController = TextEditingController(
        text: widget.source!.amount.toStringAsFixed(2),
      );
      selectedColor = Color(widget.source!.colorValue);
    }
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
      title: (widget.source == null)
          ? "New Money Source"
          : "Update Money Source",

      formKey: _formKey,
      onSave: _saveMoneySource,
      children: [
        CustomTextField(
          label: "Name",
          controller: _titleController,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter name';

            // Exclude the current source name when updating
            if (SourceNames.contains(value.toLowerCase())) {
              if (widget.source == null ||
                  value.toLowerCase() != widget.source!.title.toLowerCase()) {
                return 'The name already exists';
              }
            }

            return null;
          },
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Color:",
              style: AppTextStyles.MainFont.copyWith(fontSize: 18),
            ),
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
