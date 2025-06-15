import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ExportImportWidget extends StatelessWidget {
  const ExportImportWidget({super.key});

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
                  iconName: 'import_export',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Экспорт и импорт',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'file_download',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Экспорт в CSV',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              subtitle: Text(
                'Сохранить данные в файл',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              trailing: CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              onTap: () => _showExportDialog(context),
            ),
            Divider(color: AppTheme.lightTheme.dividerColor),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'file_upload',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Импорт из CSV',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              subtitle: Text(
                'Загрузить данные из файла',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              trailing: CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              onTap: () => _performImport(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.dialogTheme.backgroundColor,
          shape: AppTheme.lightTheme.dialogTheme.shape,
          title: Text(
            'Экспорт данных',
            style: AppTheme.lightTheme.dialogTheme.titleTextStyle,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Выберите период для экспорта:',
                style: AppTheme.lightTheme.dialogTheme.contentTextStyle,
              ),
              SizedBox(height: 2.h),
              _buildExportOption(context, 'Последний месяц',
                  () => _performExport(context, 'month')),
              _buildExportOption(context, 'Последние 3 месяца',
                  () => _performExport(context, '3months')),
              _buildExportOption(context, 'Последний год',
                  () => _performExport(context, 'year')),
              _buildExportOption(
                  context, 'Все данные', () => _performExport(context, 'all')),
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
          ],
        );
      },
    );
  }

  Widget _buildExportOption(
      BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
      onTap: onTap,
      dense: true,
    );
  }

  void _performExport(BuildContext context, String period) {
    Navigator.pop(context);

    // Simulate export process
    Fluttertoast.showToast(
      msg: 'Данные экспортированы в Downloads/expenses_$period.csv',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
    );
  }

  void _performImport(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.dialogTheme.backgroundColor,
          shape: AppTheme.lightTheme.dialogTheme.shape,
          title: Text(
            'Импорт данных',
            style: AppTheme.lightTheme.dialogTheme.titleTextStyle,
          ),
          content: Text(
            'Выберите CSV файл для импорта. Существующие данные будут дополнены новыми записями.',
            style: AppTheme.lightTheme.dialogTheme.contentTextStyle,
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
                Fluttertoast.showToast(
                  msg: 'Импортировано 45 записей из файла',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  textColor: Colors.white,
                );
              },
              child: Text(
                'Выбрать файл',
                style:
                    TextStyle(color: AppTheme.lightTheme.colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
