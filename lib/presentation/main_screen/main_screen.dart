import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../analytics_dashboard_screen/analytics_dashboard_screen.dart';
import '../expense_entry_screen/expense_entry_screen.dart';
import '../expense_history_screen/expense_history_screen.dart';
import '../settings_screen/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AnalyticsDashboardScreen(),
    const ExpenseEntryScreen(),
    const ExpenseHistoryScreen(),
    const SettingsScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.analytics),
      label: 'Аналитика',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.add_circle),
      label: 'Добавить',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'История',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Настройки',
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Haptic feedback при переключении вкладок
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        selectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall,
        elevation: 8,
        items: _bottomNavItems,
      ),
    );
  }
}
