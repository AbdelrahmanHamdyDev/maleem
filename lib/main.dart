import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maleem/Screen/HomeScreen.dart';

import 'Model/Expense.dart';
import 'Model/ExpenseGroup.dart';
import 'Model/MoneySource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MoneySourceAdapter());
  Hive.registerAdapter(ExpenseGroupAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(ExpenseTypeAdapter());

  await Hive.openBox<MoneySource>('sourcesBox');
  await Hive.openBox<ExpenseGroup>('groupsBox');
  await Hive.openBox<Expense>('expensesBox');

  runApp(
    DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightScheme =
            lightDynamic ??
            ColorScheme.fromSeed(seedColor: const Color(0xFF27548A));
        ColorScheme darkScheme =
            darkDynamic ??
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF4F1C51),
              brightness: Brightness.dark,
            );
        return MaterialApp(
          theme: ThemeData(colorScheme: lightScheme),
          darkTheme: ThemeData(colorScheme: darkScheme),
          home: Homescreen(),
        );
      },
    ),
  );
}
