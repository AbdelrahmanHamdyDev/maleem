import 'package:hive/hive.dart';
part 'MoneySource.g.dart';

@HiveType(typeId: 3)
class MoneySource {
  @HiveField(0)
  String name;

  @HiveField(1)
  double amount;

  @HiveField(2)
  int colorValue;

  MoneySource({
    required this.name,
    required this.amount,
    required this.colorValue,
  });
}
