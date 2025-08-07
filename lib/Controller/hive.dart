import 'package:hive/hive.dart';
import 'package:maleem/Model/Expense.dart';
import 'package:maleem/Model/ExpenseGroup.dart';
import 'package:maleem/Model/MoneySource.dart';

class HiveController {
  List<MoneySource> getMoneySources() {
    final box = Hive.box<MoneySource>('sourcesBox');
    return box.values.toList();
  }

  List<ExpenseGroup> getGroups() {
    final box = Hive.box<ExpenseGroup>('groupsBox');
    return box.values.toList();
  }

  List<Expense> getExpenses() {
    final box = Hive.box<Expense>('expensesBox');
    return box.values.toList();
  }
}
