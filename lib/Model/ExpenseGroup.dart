import 'package:hive/hive.dart';
part 'ExpenseGroup.g.dart';

@HiveType(typeId: 1)
class ExpenseGroup extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? notes;

  ExpenseGroup({required this.name, this.notes});
}
