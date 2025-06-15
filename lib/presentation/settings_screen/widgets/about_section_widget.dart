import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AboutSectionWidget extends StatelessWidget {
  final String appVersion;
  final String buildNumber;

  const AboutSectionWidget({
    super.key,
    required this.appVersion,
    required this.buildNumber,
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
                  iconName: 'info_outline',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'О приложении',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Версия приложения',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              subtitle: Text(
                '$appVersion (сборка $buildNumber)',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              leading: CustomIconWidget(
                iconName: 'apps',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            Divider(color: AppTheme.lightTheme.dividerColor),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Архитектура',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              subtitle: Text(
                'Полностью автономное приложение',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              leading: CustomIconWidget(
                iconName: 'offline_bolt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'security',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Конфиденциальность',
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Все ваши данные хранятся только на устройстве. Приложение не требует подключения к интернету и не передает информацию на внешние серверы.',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildFeatureChip('Без рекламы', 'block'),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildFeatureChip('Без интернета', 'wifi_off'),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: _buildFeatureChip('Открытый код', 'code'),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildFeatureChip('Бесплатно', 'money_off'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label, String iconName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Flexible(
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
