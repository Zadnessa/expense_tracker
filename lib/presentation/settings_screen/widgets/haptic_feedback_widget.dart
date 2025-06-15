import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class HapticFeedbackWidget extends StatelessWidget {
  final bool hapticFeedbackEnabled;
  final Function(bool) onHapticFeedbackChanged;

  const HapticFeedbackWidget({
    super.key,
    required this.hapticFeedbackEnabled,
    required this.onHapticFeedbackChanged,
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
                  iconName: 'vibration',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Тактильная обратная связь',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            SwitchListTile(
              value: hapticFeedbackEnabled,
              onChanged: onHapticFeedbackChanged,
              title: Text(
                'Вибрация при нажатии',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              subtitle: Text(
                hapticFeedbackEnabled ? 'Включена' : 'Отключена',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              activeColor: AppTheme.lightTheme.colorScheme.primary,
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(height: 1.h),
            ElevatedButton(
              onPressed: hapticFeedbackEnabled
                  ? () {
                      HapticFeedback.mediumImpact();
                    }
                  : null,
              style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.disabled)) {
                    return AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.12);
                  }
                  return AppTheme.lightTheme.colorScheme.primary;
                }),
              ),
              child: Text(
                'Тест вибрации',
                style: TextStyle(
                  color: hapticFeedbackEnabled
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
