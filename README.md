# Maleem

**Maleem** is a Flutter-based personal expense tracker that helps you manage income, expenses, and track your spending using grouped categories and multiple money sources.

## Features

- Manage multiple money sources with custom colors
- Create and assign expenses to groups
- Filter expenses by group or money source
- Delete expenses using swipe
- Data stored locally using Hive

## Project Structure

```
lib/
├── Model/
│   ├── Expense.dart
│   ├── ExpenseGroup.dart
│   └── MoneySource.dart
├── Controller/
│   └── hive.dart
├── Screen/
│   ├── Homescreen.dart
|   ├── FilterScreen.dart
│   └── Widget/
│       ├── Expense.dart
|       ├── Expenses_Viewer.dart
│       └── MoneySource.dart
├── Main.dart
├── app_text_styles.dart
```

> **This app is still in early development.**