import 'package:hive/hive.dart';
import 'package:maleem/model/Expense.dart';
import 'package:maleem/model/ExpenseGroup.dart';
import 'package:maleem/model/MoneySource.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class HiveController {
  //Featch data
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

  double getTotalMoneySourceAmount() {
    final moneySourceBox = Hive.box<MoneySource>('sourcesBox');
    double total = 0;

    for (final source in moneySourceBox.values) {
      total += source.amount;
    }

    return total;
  }

  //Filter Data
  List<Expense> getExpensesByGroup(String groupId) {
    final box = Hive.box<Expense>('expensesBox');
    return box.values.where((expense) => expense.groupId == groupId).toList();
  }

  List<Expense> getExpensesByMoneySource(String sourceId) {
    final box = Hive.box<Expense>('expensesBox');
    return box.values.where((expense) => expense.sourceId == sourceId).toList();
  }

  //get title
  List<String> getMoneySourceName({String? excludeId}) {
    final box = Hive.box<MoneySource>('sourcesBox');
    final List<String> sourceNames = box.values
        .where((s) => excludeId == null || s.id == excludeId)
        .map((source) => source.title.toLowerCase())
        .toList();

    return sourceNames;
  }

  List<String> getGroupsName({String? excludeId}) {
    final box = Hive.box<ExpenseGroup>('groupsBox');

    final List<String> groupNames = box.values
        .where((s) => excludeId == null || s.id == excludeId)
        .map((group) => group.title.toLowerCase())
        .toList();

    return groupNames;
  }

  //Still Exist?
  bool checkGroupExist(String checkId) {
    final box = Hive.box<ExpenseGroup>('groupsBox');
    bool exists = box.values.any((item) => item.id == checkId);
    return exists;
  }

  bool checkMoneySourceExist(String checkId) {
    final box = Hive.box<MoneySource>('sourcesBox');
    bool exists = box.values.any((item) => item.id == checkId);
    return exists;
  }

  //add in the hive
  void addGroup({required String title, required String note}) {
    final box = Hive.box<ExpenseGroup>('groupsBox');
    box.add(
      ExpenseGroup(
        id: _uuid.v4(),
        title: title,
        notes: (note.isEmpty) ? null : note,
      ),
    );
  }

  void addMoneySource({
    required String title,
    required double amount,
    required int colorValue,
  }) {
    final box = Hive.box<MoneySource>('sourcesBox');
    box.add(
      MoneySource(
        id: _uuid.v4(),
        title: title,
        amount: amount,
        colorValue: colorValue,
      ),
    );
  }

  void addExpense({
    required String title,
    required double amount,
    required String sourceId,
    required String? groupId,
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
    final source = sourcesBox.values.firstWhere((s) => s.id == sourceId);
    source.amount = (type == ExpenseType.expense)
        ? (source.amount - amount)
        : (source.amount + amount);

    source.save();
  }

  //update the exist in the hive
  void updateGroup({
    required ExpenseGroup group,
    required String title,
    required String note,
  }) {
    group
      ..title = title
      ..notes = (note.isEmpty) ? null : note;

    group.save();
  }

  void updateMoneySource({
    required MoneySource source,
    required String title,
    required double amount,
    required int colorValue,
  }) {
    source
      ..title = title
      ..amount = amount
      ..colorValue = colorValue;

    source.save();
  }

  void updateExpense({
    required Expense expense,
    required String title,
    required double amount,
    required String sourceId,
    required String? groupId,
    required DateTime date,
    required ExpenseType type,
  }) {
    final sourcesBox = Hive.box<MoneySource>('sourcesBox');

    final oldSource = sourcesBox.values.firstWhere(
      (s) => s.id == expense.sourceId,
    );
    if (expense.type == ExpenseType.expense) {
      oldSource.amount += expense.amount;
    } else {
      oldSource.amount -= expense.amount;
    }
    oldSource.save();

    expense
      ..title = title
      ..amount = amount
      ..sourceId = sourceId
      ..groupId = (groupId == "StandAlone") ? null : groupId
      ..date = date
      ..type = type;
    expense.save();

    final newSource = sourcesBox.values.firstWhere((s) => s.id == sourceId);
    if (type == ExpenseType.expense) {
      newSource.amount -= amount;
    } else {
      newSource.amount += amount;
    }
    newSource.save();
  }

  //Delete from the hive box
  Future<void> deleteExpense(Expense selectedExpense) async {
    final expensesBox = Hive.box<Expense>('expensesBox');

    final keysToDelete = expensesBox.keys
        .where((key) => expensesBox.get(key)!.id == selectedExpense.id)
        .toList();

    await expensesBox.deleteAll(keysToDelete);

    final sourcesBox = Hive.box<MoneySource>('sourcesBox');
    final source = sourcesBox.values.firstWhere(
      (s) => s.id == selectedExpense.sourceId,
    );
    source.amount = (selectedExpense.type == ExpenseType.expense)
        ? (source.amount + selectedExpense.amount)
        : (source.amount - selectedExpense.amount);

    source.save();
  }
}
