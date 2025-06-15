import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class ExportMenuWidget extends StatelessWidget {
  final VoidCallback onExport;

  const ExportMenuWidget({
    super.key,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: CustomIconWidget(
        iconName: 'more_vert',
        size: 24,
        color: AppTheme.lightTheme.colorScheme.onSurface,
      ),
      onSelected: (String value) {
        switch (value) {
          case 'export_csv':
            _showExportDialog(context);
            break;
          case 'export_pdf':
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Экспорт в PDF скоро будет доступен'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'export_csv',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'file_download',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              SizedBox(width: 12),
              Text(
                'Экспорт CSV',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'export_pdf',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'picture_as_pdf',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              SizedBox(width: 12),
              Text(
                'Экспорт PDF',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'settings',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              SizedBox(width: 12),
              Text(
                'Настройки',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 8,
      color: AppTheme.lightTheme.colorScheme.surface,
    );
  }

  void _showExportDialog(BuildContext context) {
    DateTime startDate = DateTime.now().subtract(Duration(days: 30));
    DateTime endDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Экспорт данных',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выберите период для экспорта:',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16),

                  // Date Range Selection
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'С',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 4),
                            InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: startDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    startDate = picked;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        AppTheme.lightTheme.colorScheme.outline,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'calendar_today',
                                      size: 16,
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${startDate.day}.${startDate.month.toString().padLeft(2, '0')}.${startDate.year}',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'По',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 4),
                            InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: endDate,
                                  firstDate: startDate,
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    endDate = picked;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        AppTheme.lightTheme.colorScheme.outline,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'calendar_today',
                                      size: 16,
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${endDate.day}.${endDate.month.toString().padLeft(2, '0')}.${endDate.year}',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onExport();
                  },
                  child: Text('Экспорт'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
