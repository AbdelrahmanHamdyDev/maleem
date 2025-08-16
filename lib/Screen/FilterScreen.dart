import 'package:flutter/material.dart';
import 'package:maleem/Controller/hive.dart';
import 'package:maleem/Model/Expense.dart';
import 'package:maleem/Screen/SaveGroupScreen.dart';
import 'package:maleem/Screen/Widget/Expenses_Viewer.dart';

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: ExpensesViewer(
                  items: widget.filteredItems,
                  onRefresh: () => setState(() {}),
                  is_expenseGroupAppear: false,
                ),
              ),
      ),
    );
  }
}
