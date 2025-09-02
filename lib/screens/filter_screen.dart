import 'package:flutter/material.dart';
import 'package:maleem/model/Expense.dart';
import 'package:maleem/screens/widgets/expenses_viewer.dart';
import 'package:maleem/core/hive_service.dart';
import 'package:maleem/screens/save_group_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum filterType { group, source }

class Filterscreen extends StatefulWidget {
  const Filterscreen({
    super.key,
    required this.title,
    required this.filteredItems,
    required this.type,
  });

  final List<Expense> filteredItems;
  final filterType type;
  final dynamic title;

  @override
  State<Filterscreen> createState() => _FilterscreenState();
}

class _FilterscreenState extends State<Filterscreen> {
  final hiveController = HiveController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          if (widget.type == filterType.group)
            IconButton(
              onPressed: () {
                if (widget.filteredItems.isEmpty) return;

                final group = hiveController.getGroups().firstWhere(
                  (g) => g.id == widget.filteredItems.first.groupId,
                );

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SaveGroupScreen(group: group),
                  ),
                );
              },
              icon: const Icon(Icons.mode),
            ),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            Navigator.pop(context, true);
          }
        },
        child: (widget.filteredItems.isEmpty)
            ? const Center(child: Text("No Expenses Found"))
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: ExpensesViewer(
                  items: widget.filteredItems,
                  onRefresh: () => setState(() {}),
                  is_expenseGroupAppear: (widget.type == filterType.group)
                      ? false
                      : true,
                ),
              ),
      ),
    );
  }
}
