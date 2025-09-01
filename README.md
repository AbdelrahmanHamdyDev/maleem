# Maleem

**Maleem** is a Flutter-based **personal expense tracker** that helps you manage income, expenses, and track your spending using grouped categories and multiple money sources.

This is **Version 1 (v1)** of the app — the foundation release with core features and clean architecture.

## Features

- **Dashboard overview** of total balance, money sources, and transactions
- Manage **multiple money sources** with custom colors (cash, bank accounts, wallets)
- Create and assign **expense groups** (e.g., trips, bills, shopping)
- **Filter and search** by group or money source
- **Dynamic Color Support** → adapts to system Material You colors when available, and falls back to custom theme colors when not
- **Add, update, and delete** entries (expenses, income, groups, sources) with adaptive UI refresh
- **Swipe to delete** expenses and sources
- Data stored locally using **Hive** for fast and secure persistence
- Integrated input validation across forms

---

## Project Structure

```bash
lib/
├── core/
│   ├── app_text_styles.dart
│   └── hive_service.dart
├── models/
│   ├── expense.dart
│   ├── expense.g.dart
│   ├── money_source.dart
│   ├── money_source.g.dart
│   ├── expense_group.dart
│   └── expense_group.g.dart
├── screens/
│   ├── home_screen.dart
│   ├── save_expense_screen.dart
│   ├── save_money_source_screen.dart
│   ├── save_group_screen.dart
│   └── filter_screen.dart
├── widgets/
│   ├── expense_item.dart
│   ├── money_source_card.dart
│   ├── expenses_viewer.dart
│   ├── custom_text_field.dart
│   ├── date_picker.dart
│   ├── form_scaffold.dart
│   └── done_fab.dart
└── main.dart
```

---

## Screenshots

| Dark Dashboard                               | Add Expense                                 | Add Money Sources                                   | Add Groups                            |
| -------------------------------------------- | ------------------------------------------- | --------------------------------------------------- | ------------------------------------- |
| ![Dashboard](screenshots/dark_dashboard.png) | ![Add Expense](screenshots/add_expense.png) | ![Money Sources](screenshots/add_money_sources.png) | ![Groups](screenshots/add_groups.png) |

| Light Dashboard                               | Money Sources                                   | Groups                            |
| --------------------------------------------- | ----------------------------------------------- | --------------------------------- |
| ![Dashboard](screenshots/light_dashboard.png) | ![Money Sources](screenshots/money_sources.png) | ![Groups](screenshots/groups.png) |

---
