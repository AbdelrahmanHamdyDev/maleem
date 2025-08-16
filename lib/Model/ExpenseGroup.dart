import 'package:hive/hive.dart';
part 'ExpenseGroup.g.dart';

@HiveType(typeId: 1)
class ExpenseGroup extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? notes;

  ExpenseGroup({required this.id, required this.title, this.notes});
}
