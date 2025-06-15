import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './widgets/about_section_widget.dart';
import './widgets/backup_functionality_widget.dart';
import './widgets/currency_configuration_widget.dart';
import './widgets/database_management_widget.dart';
import './widgets/export_import_widget.dart';
import './widgets/font_size_adjustment_widget.dart';
import './widgets/haptic_feedback_widget.dart';
import './widgets/quick_amount_buttons_widget.dart';
import './widgets/theme_selection_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Mock settings data
  final Map<String, dynamic> settingsData = {
    "theme": "system", // light, dark, system
    "fontSize": 16.0,
    "currency": "₽",
    "exchangeRate": 1.0,
    "hapticFeedback": true,
    "quickAmounts": [100.0, 500.0, 1000.0, 2000.0, 5000.0],
    "lastBackup": "2024-01-15 14:30:00",
    "autoBackup": true,
    "storageUsed": "2.5 МБ",
    "totalTransactions": 1247,
    "appVersion": "1.0.0",
    "buildNumber": "100"
  };

  String selectedTheme = "system";
  double fontSize = 16.0;
  String selectedCurrency = "₽";
  double exchangeRate = 1.0;
  bool hapticFeedbackEnabled = true;
  List<double> quickAmounts = [100.0, 500.0, 1000.0, 2000.0, 5000.0];
  bool autoBackupEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        selectedTheme = prefs.getString('theme') ?? settingsData["theme"];
        fontSize = prefs.getDouble('fontSize') ?? settingsData["fontSize"];
        selectedCurrency =
            prefs.getString('currency') ?? settingsData["currency"];
        exchangeRate =
            prefs.getDouble('exchangeRate') ?? settingsData["exchangeRate"];
        hapticFeedbackEnabled =
            prefs.getBool('hapticFeedback') ?? settingsData["hapticFeedback"];
        autoBackupEnabled =
            prefs.getBool('autoBackup') ?? settingsData["autoBackup"];

        // Load quick amounts
        final quickAmountsString = prefs.getStringList('quickAmounts');
        if (quickAmountsString != null) {
          quickAmounts =
              quickAmountsString.map((e) => double.parse(e)).toList();
        }
      });
    } catch (e) {
      _showErrorToast('Ошибка загрузки настроек');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme', selectedTheme);
      await prefs.setDouble('fontSize', fontSize);
      await prefs.setString('currency', selectedCurrency);
      await prefs.setDouble('exchangeRate', exchangeRate);
      await prefs.setBool('hapticFeedback', hapticFeedbackEnabled);
      await prefs.setBool('autoBackup', autoBackupEnabled);
      await prefs.setStringList(
          'quickAmounts', quickAmounts.map((e) => e.toString()).toList());

      _showSuccessToast('Настройки сохранены');
    } catch (e) {
      _showErrorToast('Ошибка сохранения настроек');
    }
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.error,
      textColor: Colors.white,
    );
  }

  void _onThemeChanged(String theme) {
    setState(() {
      selectedTheme = theme;
    });
    _saveSettings();
  }

  void _onFontSizeChanged(double size) {
    setState(() {
      fontSize = size;
    });
    _saveSettings();
  }

  void _onCurrencyChanged(String currency, double rate) {
    setState(() {
      selectedCurrency = currency;
      exchangeRate = rate;
    });
    _saveSettings();
  }

  void _onHapticFeedbackChanged(bool enabled) {
    setState(() {
      hapticFeedbackEnabled = enabled;
    });
    if (enabled) {
      HapticFeedback.lightImpact();
    }
    _saveSettings();
  }

  void _onQuickAmountsChanged(List<double> amounts) {
    setState(() {
      quickAmounts = amounts;
    });
    _saveSettings();
  }

  void _onAutoBackupChanged(bool enabled) {
    setState(() {
      autoBackupEnabled = enabled;
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Настройки',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Section
            ThemeSelectionWidget(
              selectedTheme: selectedTheme,
              onThemeChanged: _onThemeChanged,
            ),

            SizedBox(height: 3.h),

            // Font Size Section
            FontSizeAdjustmentWidget(
              fontSize: fontSize,
              onFontSizeChanged: _onFontSizeChanged,
            ),

            SizedBox(height: 3.h),

            // Currency Section
            CurrencyConfigurationWidget(
              selectedCurrency: selectedCurrency,
              exchangeRate: exchangeRate,
              onCurrencyChanged: _onCurrencyChanged,
            ),

            SizedBox(height: 3.h),

            // Haptic Feedback Section
            HapticFeedbackWidget(
              hapticFeedbackEnabled: hapticFeedbackEnabled,
              onHapticFeedbackChanged: _onHapticFeedbackChanged,
            ),

            SizedBox(height: 3.h),

            // Quick Amount Buttons Section
            QuickAmountButtonsWidget(
              quickAmounts: quickAmounts,
              onQuickAmountsChanged: _onQuickAmountsChanged,
            ),

            SizedBox(height: 3.h),

            // Backup Section
            BackupFunctionalityWidget(
              lastBackup: settingsData["lastBackup"],
              autoBackupEnabled: autoBackupEnabled,
              onAutoBackupChanged: _onAutoBackupChanged,
            ),

            SizedBox(height: 3.h),

            // Export/Import Section
            ExportImportWidget(),

            SizedBox(height: 3.h),

            // Database Management Section
            DatabaseManagementWidget(
              storageUsed: settingsData["storageUsed"],
              totalTransactions: settingsData["totalTransactions"],
            ),

            SizedBox(height: 3.h),

            // About Section
            AboutSectionWidget(
              appVersion: settingsData["appVersion"],
              buildNumber: settingsData["buildNumber"],
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
