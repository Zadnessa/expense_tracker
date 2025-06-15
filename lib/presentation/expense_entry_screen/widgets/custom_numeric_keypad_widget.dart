import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CustomNumericKeypadWidget extends StatelessWidget {
  final Function(String) onInput;

  const CustomNumericKeypadWidget({
    super.key,
    required this.onInput,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      child: Column(
        children: [
          // First row: 1, 2, 3
          Expanded(
            child: Row(
              children: [
                _buildKeypadButton('1'),
                SizedBox(width: 2.w),
                _buildKeypadButton('2'),
                SizedBox(width: 2.w),
                _buildKeypadButton('3'),
              ],
            ),
          ),
          SizedBox(height: 2.w),

          // Second row: 4, 5, 6
          Expanded(
            child: Row(
              children: [
                _buildKeypadButton('4'),
                SizedBox(width: 2.w),
                _buildKeypadButton('5'),
                SizedBox(width: 2.w),
                _buildKeypadButton('6'),
              ],
            ),
          ),
          SizedBox(height: 2.w),

          // Third row: 7, 8, 9
          Expanded(
            child: Row(
              children: [
                _buildKeypadButton('7'),
                SizedBox(width: 2.w),
                _buildKeypadButton('8'),
                SizedBox(width: 2.w),
                _buildKeypadButton('9'),
              ],
            ),
          ),
          SizedBox(height: 2.w),

          // Fourth row: Clear, 0, Delete
          Expanded(
            child: Row(
              children: [
                _buildKeypadButton('clear', isSpecial: true),
                SizedBox(width: 2.w),
                _buildKeypadButton('0'),
                SizedBox(width: 2.w),
                _buildKeypadButton('delete', isSpecial: true),
              ],
            ),
          ),
          SizedBox(height: 2.w),

          // Fifth row: Decimal comma
          Expanded(
            child: Row(
              children: [
                Expanded(child: Container()),
                SizedBox(width: 2.w),
                _buildKeypadButton(','),
                SizedBox(width: 2.w),
                Expanded(child: Container()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(String value, {bool isSpecial = false}) {
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        child: Material(
          color: isSpecial
              ? AppTheme.lightTheme.colorScheme.secondaryContainer
              : AppTheme.lightTheme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              HapticFeedback.lightImpact();
              onInput(value);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Center(
                child: _buildButtonContent(value, isSpecial),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(String value, bool isSpecial) {
    if (value == 'delete') {
      return CustomIconWidget(
        iconName: 'backspace',
        color: AppTheme.lightTheme.colorScheme.onSecondaryContainer,
        size: 6.w,
      );
    } else if (value == 'clear') {
      return Text(
        'C',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
      );
    } else {
      return Text(
        value,
        style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }
}
