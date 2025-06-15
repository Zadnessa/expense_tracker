import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class BackupFunctionalityWidget extends StatelessWidget {
  final String lastBackup;
  final bool autoBackupEnabled;
  final Function(bool) onAutoBackupChanged;

  const BackupFunctionalityWidget({
    super.key,
    required this.lastBackup,
    required this.autoBackupEnabled,
    required this.onAutoBackupChanged,
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
                  iconName: 'backup',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Резервное копирование',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Последняя копия',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              subtitle: Text(
                _formatBackupDate(lastBackup),
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              trailing: CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            SizedBox(height: 1.h),
            ElevatedButton.icon(
              onPressed: _performManualBackup,
              icon: CustomIconWidget(
                iconName: 'cloud_upload',
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                'Создать копию сейчас',
                style: TextStyle(color: Colors.white),
              ),
              style: AppTheme.lightTheme.elevatedButtonTheme.style,
            ),
            SizedBox(height: 2.h),
            SwitchListTile(
              value: autoBackupEnabled,
              onChanged: onAutoBackupChanged,
              title: Text(
                'Автоматическое копирование',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              subtitle: Text(
                autoBackupEnabled ? 'Еженедельно' : 'Отключено',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              activeColor: AppTheme.lightTheme.colorScheme.primary,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  String _formatBackupDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString.replaceAll(' ', 'T'));
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Сегодня в ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'Вчера в ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} дн. назад';
      } else {
        return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }

  void _performManualBackup() {
    // Simulate backup process
    Fluttertoast.showToast(
      msg: 'Резервная копия создана успешно',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
    );
  }
}
