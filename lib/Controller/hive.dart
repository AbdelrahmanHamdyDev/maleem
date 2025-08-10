import 'package:hive/hive.dart';
import 'package:maleem/Model/Expense.dart';
import 'package:maleem/Model/ExpenseGroup.dart';
import 'package:maleem/Model/MoneySource.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

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

  List<String> getMoneySourceName() {
    final box = Hive.box<MoneySource>('sourcesBox');
    final List<String> sourceNames = box.values
        .map((source) => source.name)
        .toList();

    return sourceNames;
  }

  List<String> getGroupsName() {
    final box = Hive.box<ExpenseGroup>('groupsBox');

    final List<String> groupNames = box.values
        .map((group) => group.name)
        .toList();

    return groupNames;
  }

  bool checkGroupExist(String nameToCheck) {
    final box = Hive.box<ExpenseGroup>('groupsBox');
    bool exists = box.values.any((item) => item.name == nameToCheck);
    return exists;
  }

  bool checkMoneySourceExist(String nameToCheck) {
    final box = Hive.box<MoneySource>('sourcesBox');
    bool exists = box.values.any((item) => item.name == nameToCheck);
    return exists;
  }

  void addGroup({required String name, required String note}) {
    final box = Hive.box<ExpenseGroup>('groupsBox');
    box.add(ExpenseGroup(name: name, notes: (note.isEmpty) ? null : note));
  }

  void addMoneySource({
    required String name,
    required double amount,
    required int colorValue,
  }) {
    final box = Hive.box<MoneySource>('sourcesBox');
    box.add(MoneySource(name: name, amount: amount, colorValue: colorValue));
  }

  void addExpense({
    required String title,
    required double amount,
    required String sourceId,
    required String groupId,
    required DateTime date,
    required ExpenseType type,
  }) {
    final expensesBox = Hive.box<Expense>('expensesBox');
    expensesBox.add(
      Expense(
        id: _uuid.v4(),
        title: title,
        amount: amount,
        sourceId: sourceId,
        groupId: (groupId == "StandAlone") ? null : groupId,
        date: date,
        type: type,
      ),
    );
    final sourcesBox = Hive.box<MoneySource>('sourcesBox');
    final source = sourcesBox.values.firstWhere((s) => s.name == sourceId);
    source.amount = (type == ExpenseType.expense)
        ? (source.amount - amount)
        : (source.amount + amount);

    source.save();
  }

  void deleteExpense(Expense Selectedexpense) async {
    final expensesBox = Hive.box<Expense>('expensesBox');

    final keysToDelete = expensesBox.keys
        .where((key) => expensesBox.get(key)!.id == Selectedexpense.id)
        .toList();

    await expensesBox.deleteAll(keysToDelete);

    final sourcesBox = Hive.box<MoneySource>('sourcesBox');
    final source = sourcesBox.values.firstWhere(
      (s) => s.name == Selectedexpense.sourceId,
    );
    source.amount = (Selectedexpense.type == ExpenseType.expense)
        ? (source.amount - Selectedexpense.amount)
        : (source.amount + Selectedexpense.amount);

    source.save();
  }
}
