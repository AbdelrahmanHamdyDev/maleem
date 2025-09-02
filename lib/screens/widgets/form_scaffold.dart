import 'package:flutter/material.dart';
import 'package:maleem/core/app_text_styles.dart';
import 'done_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      appBar: AppBar(title: Text(title, style: AppTextStyles.MainFont)),
      floatingActionButton: DoneFab(onPressed: onSave),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 20.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
