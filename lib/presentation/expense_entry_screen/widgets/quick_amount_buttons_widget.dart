import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class QuickAmountButtonsWidget extends StatelessWidget {
  final List<double> amounts;
  final Function(double) onAmountSelected;

  const QuickAmountButtonsWidget({
    super.key,
    required this.amounts,
    required this.onAmountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: amounts.length,
        separatorBuilder: (context, index) => SizedBox(width: 3.w),
        itemBuilder: (context, index) {
          final amount = amounts[index];
          return _buildQuickAmountButton(amount);
        },
      ),
    );
  }

  Widget _buildQuickAmountButton(double amount) {
    return Container(
      constraints: BoxConstraints(minWidth: 20.w),
      child: Material(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            HapticFeedback.selectionClick();
            onAmountSelected(amount);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Center(
              child: Text(
                _formatQuickAmount(amount),
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatQuickAmount(double amount) {
    if (amount >= 1000) {
      return '\${(amount / 1000).toStringAsFixed(0)}к ₽';
    } else {
      return '\${amount.toStringAsFixed(0)} ₽';
    }
  }
}
