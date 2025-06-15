import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class DatabaseManagementWidget extends StatelessWidget {
  final String storageUsed;
  final int totalTransactions;

  const DatabaseManagementWidget({
    super.key,
    required this.storageUsed,
    required this.totalTransactions,
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
                  iconName: 'storage',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Управление данными',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Использовано места',
                    storageUsed,
                    'folder',
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildStatCard(
                    'Всего операций',
                    _formatNumber(totalTransactions),
                    'receipt_long',
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            OutlinedButton.icon(
              onPressed: () => _showClearDataDialog(context),
              icon: CustomIconWidget(
                iconName: 'delete_outline',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 20,
              ),
              label: Text(
                'Очистить все данные',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
              style: AppTheme.lightTheme.outlinedButtonTheme.style?.copyWith(
                side: WidgetStateProperty.all(
                  BorderSide(color: AppTheme.lightTheme.colorScheme.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String iconName) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)} тыс';
    }
    return number.toString();
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.dialogTheme.backgroundColor,
          shape: AppTheme.lightTheme.dialogTheme.shape,
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Внимание!',
                style: AppTheme.lightTheme.dialogTheme.titleTextStyle?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Вы действительно хотите удалить все данные?',
                style: AppTheme.lightTheme.dialogTheme.contentTextStyle,
              ),
              SizedBox(height: 1.h),
              Text(
                'Это действие нельзя отменить. Будут удалены:',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              SizedBox(height: 1.h),
              Text(
                '• Все записи о расходах\n• История операций\n• Настройки категорий',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Отмена',
                style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _performClearData();
              },
              child: Text(
                'Удалить все',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performClearData() {
    // Simulate data clearing process
    Fluttertoast.showToast(
      msg: 'Все данные успешно удалены',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
    );
  }
}
