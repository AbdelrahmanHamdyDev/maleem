import 'package:flutter/material.dart';
import 'done_fab.dart';

class FormScaffold extends StatelessWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSave;
  final List<Widget> children;

  const FormScaffold({
    super.key,
    required this.title,
    required this.formKey,
    required this.onSave,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: DoneFab(onPressed: onSave),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
