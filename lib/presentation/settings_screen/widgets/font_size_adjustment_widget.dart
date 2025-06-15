import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class FontSizeAdjustmentWidget extends StatelessWidget {
  final double fontSize;
  final Function(double) onFontSizeChanged;

  const FontSizeAdjustmentWidget({
    super.key,
    required this.fontSize,
    required this.onFontSizeChanged,
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
                  iconName: 'text_fields',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Размер шрифта',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Пример: 1 500 ₽',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Text(
                  'А',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                Expanded(
                  child: Slider(
                    value: fontSize,
                    min: 12.0,
                    max: 24.0,
                    divisions: 12,
                    onChanged: onFontSizeChanged,
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                    inactiveColor: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                Text(
                  'А',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
              ],
            ),
            Text(
              '${fontSize.toInt()} пт',
              style: AppTheme.lightTheme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
