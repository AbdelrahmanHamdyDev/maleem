import 'package:hive/hive.dart';
part 'MoneySource.g.dart';

@HiveType(typeId: 3)
class MoneySource extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  int colorValue;

  MoneySource({
    required this.id,
    required this.title,
    required this.amount,
    required this.colorValue,
  });
}
