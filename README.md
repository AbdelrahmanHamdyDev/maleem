# Maleem

**Maleem** is a Flutter-based personal expense tracker that helps you manage income, expenses, and track your spending using grouped categories and multiple money sources.

## 📦 Current Features

- 🔹 Hive local database setup
- 🔹 Models for `Expense`, `ExpenseGroup`, and `MoneySource`
- 🔹 Home screen UI
  - Horizontal list of money sources at the top
  - Vertical list of expenses at the bottom
- 🔹 Dummy data support to simulate real usage

## 📂 Project Structure

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
│   └── Widget/
│       ├── Expense.dart
│       └── MoneySource.dart
```

> 🧪 **This app is still in early development.**