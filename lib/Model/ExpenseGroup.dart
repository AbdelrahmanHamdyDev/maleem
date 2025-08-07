import 'package:hive/hive.dart';
part 'ExpenseGroup.g.dart';

@HiveType(typeId: 1)
class ExpenseGroup extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? notes;

  @HiveField(3)
  DateTime createdAt;

  ExpenseGroup({
    required this.id,
    required this.name,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
