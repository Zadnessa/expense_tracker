// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../presentation/expense_entry_screen/expense_entry_screen.dart';
import '../presentation/category_selection_screen/category_selection_screen.dart';
import '../presentation/expense_history_screen/expense_history_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/analytics_dashboard_screen/analytics_dashboard_screen.dart';

class AppRoutes {
  static const String initial =
      '/expense-entry-screen'; // Изменено на прямой переход к экрану ввода расходов
  static const String expenseEntryScreen = '/expense-entry-screen';
  static const String categorySelectionScreen = '/category-selection-screen';
  static const String expenseHistoryScreen = '/expense-history-screen';
  static const String analyticsDashboardScreen = '/analytics-dashboard-screen';
  static const String settingsScreen = '/settings-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const ExpenseEntryScreen(),
    expenseEntryScreen: (context) => const ExpenseEntryScreen(),
    categorySelectionScreen: (context) => const CategorySelectionScreen(),
    expenseHistoryScreen: (context) => const ExpenseHistoryScreen(),
    analyticsDashboardScreen: (context) => const AnalyticsDashboardScreen(),
    settingsScreen: (context) => const SettingsScreen(),
  };
}
