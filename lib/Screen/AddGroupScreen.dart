import 'package:flutter/material.dart';
import 'package:maleem/Controller/hive.dart';
import 'package:maleem/Screen/Widget/custom_textField.dart';
import 'package:maleem/Screen/Widget/form_scaffold.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({super.key});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final HiveController hiveController = HiveController();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _noteController = TextEditingController();

  void _saveGroup() {
    if (_formKey.currentState!.validate()) {
      hiveController.addGroup(
        name: _nameController.text,
        note: _noteController.text,
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: "New Group",
      formKey: _formKey,
      onSave: _saveGroup,
      children: [
        CustomTextField(
          label: "Name",
          controller: _nameController,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter name';
            if (hiveController.checkGroupExist(value)) {
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
