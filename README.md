# Maleem

**Maleem** is a Flutter-based personal expense tracker that helps you manage income, expenses, and track your spending using grouped categories and multiple money sources.

## Features

- Manage multiple money sources with custom colors
- Create and assign expenses to groups
- Filter expenses by group or money source
- Delete expenses using swipe
- Update existing entries (money sources, groups, expenses) with adaptive UI refresh
- Data stored locally using Hive
- Dedicated UI screens for managing:  
  • Money sources  
  • Expense groups  
  • Expenses
- Integrated input validation and Hive storage for each box

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
|   ├── saveExpenseScreen.dart
|   ├── saveGroupScreen.dart
|   ├── saveMoneySourceScreen.dart
│   └── Widget/
│       ├── custom_textField.dart
│       ├── data_picker.dart
│       ├── done_fab.dart
│       ├── Expense.dart
|       ├── Expenses_Viewer.dart
│       ├── form_scaffold.dart
│       └── MoneySource.dart
├── Main.dart
├── app_text_styles.dart
```

> **This app is still in early development.**
