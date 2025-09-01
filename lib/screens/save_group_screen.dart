import 'package:flutter/material.dart';
import 'package:maleem/model/ExpenseGroup.dart';
import 'package:maleem/screens/widgets/custom_textField.dart';
import 'package:maleem/screens/widgets/form_scaffold.dart';
import 'package:maleem/core/app_text_styles.dart';
import 'package:maleem/core/hive_service.dart';

class SaveGroupScreen extends StatefulWidget {
  const SaveGroupScreen({super.key, this.group});

  final ExpenseGroup? group;

  @override
  State<SaveGroupScreen> createState() => _SaveGroupScreenState();
}

class _SaveGroupScreenState extends State<SaveGroupScreen> {
  final HiveController hiveController = HiveController();
  List<String> allGroupsName = [];
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  void _saveGroup() {
    if (!_formKey.currentState!.validate()) return;
    if (widget.group == null) {
      hiveController.addGroup(
        title: _titleController.text,
        note: _noteController.text,
      );
    } else {
      hiveController.updateGroup(
        group: widget.group!,
        title: _titleController.text,
        note: _noteController.text,
      );
    }
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    allGroupsName = hiveController.getGroupsName();
    if (widget.group != null) {
      _titleController = TextEditingController(text: widget.group!.title);
      if (widget.group!.notes != null)
        _noteController = TextEditingController(text: widget.group!.notes);
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screenItems = [
      if (widget.group == null)
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 20, bottom: 50),
          child: Text(
            "New Group",
            style: AppTextStyles.MainFont.copyWith(fontSize: 25),
          ),
        ),
      CustomTextField(
        label: "Name",
        controller: _titleController,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter name';
          if (allGroupsName.contains(value.toLowerCase())) {
            return 'The name already exists';
          }
          return null;
        },
      ),
      CustomTextField(label: "Note (Optional)", controller: _noteController),
      if (widget.group == null)
        ElevatedButton(onPressed: _saveGroup, child: const Text("New Group")),
    ];

    return (widget.group == null)
        ? SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: screenItems,
                ),
              ),
            ),
          )
        : FormScaffold(
            title: "Update Group",
            formKey: _formKey,
            onSave: _saveGroup,
            children: screenItems,
          );
  }
}
