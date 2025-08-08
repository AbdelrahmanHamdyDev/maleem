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

  List<Expense> getExpensesByGroup(String groupId) {
    final box = Hive.box<Expense>('expensesBox');
    return box.values.where((expense) => expense.groupId == groupId).toList();
  }

  List<Expense> getExpensesByMoneySource(String sourceId) {
    final box = Hive.box<Expense>('expensesBox');
    return box.values.where((expense) => expense.sourceId == sourceId).toList();
  }

  void deleteExpense(String expenseID) async {
    final expensesBox = Hive.box<Expense>('expensesBox');

    final keysToDelete = expensesBox.keys
        .where((key) => expensesBox.get(key)!.id == expenseID)
        .toList();

    await expensesBox.deleteAll(keysToDelete);
  }
}
