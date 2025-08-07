import 'package:hive/hive.dart';
part 'Expense.g.dart';

@HiveType(typeId: 2)
class Expense {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String sourceId;

  @HiveField(4)
  String? groupId;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  ExpenseType type;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.sourceId,
    this.groupId,
    required this.date,
    required this.type,
  });
}

@HiveType(typeId: 4)
enum ExpenseType {
  @HiveField(0)
  expense, // Subtracts money
  @HiveField(1)
  income, // Adds money
}
