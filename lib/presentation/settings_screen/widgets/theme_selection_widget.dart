import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ThemeSelectionWidget extends StatelessWidget {
  final String selectedTheme;
  final Function(String) onThemeChanged;

  const ThemeSelectionWidget({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.lightTheme.cardColor,
      elevation: AppTheme.lightTheme.cardTheme.elevation,
      shape: AppTheme.lightTheme.cardTheme.shape,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'palette',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Тема',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildThemeOption('light', 'Светлая'),
            _buildThemeOption('dark', 'Темная'),
            _buildThemeOption('system', 'Системная'),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String value, String label) {
    return RadioListTile<String>(
      value: value,
      groupValue: selectedTheme,
      onChanged: (String? newValue) {
        if (newValue != null) {
          onThemeChanged(newValue);
        }
      },
      title: Text(
        label,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
      activeColor: AppTheme.lightTheme.colorScheme.primary,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}
