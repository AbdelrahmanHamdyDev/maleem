import 'package:flutter/material.dart';
import 'package:maleem/core/ui_helper.dart';
import 'package:maleem/model/MoneySource.dart';
import 'package:maleem/screens/widgets/custom_textField.dart';
import 'package:maleem/screens/widgets/form_scaffold.dart';
import 'package:maleem/core/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class saveMoneySourceScreen extends StatefulWidget {
  const saveMoneySourceScreen({super.key, this.source});

  final MoneySource? source;

  @override
  State<saveMoneySourceScreen> createState() => _saveMoneySourceScreenState();
}

class _saveMoneySourceScreenState extends State<saveMoneySourceScreen> {
  List<String> SourceNames = [];
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  Color selectedColor = Colors.white;

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
      onSave: () => UIHelper.saveMoneySource(
        formKey: _formKey,
        context: context,
        hiveController: hiveController,
        titleController: _titleController,
        amountController: _amountController,
        selectedColor: selectedColor,
        source: widget.source,
      ),

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
              style: AppTextStyles.MainFont.copyWith(fontSize: 18.sp),
            ),
            InkWell(
              onTap: () async {
                final color = await UIHelper.pickColor(
                  context: context,
                  initialColor: selectedColor,
                );
                if (color != null) {
                  setState(() => selectedColor = color);
                }
              },
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: selectedColor,
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.5.w),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
