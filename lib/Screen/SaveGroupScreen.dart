import 'package:flutter/material.dart';
import 'package:maleem/Controller/hive.dart';
import 'package:maleem/Model/ExpenseGroup.dart';
import 'package:maleem/Screen/Widget/custom_textField.dart';
import 'package:maleem/Screen/Widget/form_scaffold.dart';

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
    return FormScaffold(
      title: (widget.group == null) ? "New Group" : "Update Group",
      formKey: _formKey,
      onSave: _saveGroup,
      children: [
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
        const SizedBox(height: 20),
        CustomTextField(label: "Note (Optional)", controller: _noteController),
      ],
    );
  }
}
