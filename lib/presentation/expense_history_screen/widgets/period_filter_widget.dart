import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PeriodFilterWidget extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;

  const PeriodFilterWidget({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  static const List<String> _periods = ['день', 'неделя', 'месяц', 'год'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _periods.map((period) => _buildPeriodChip(period)).toList(),
        ),
      ),
    );
  }

  Widget _buildPeriodChip(String period) {
    final bool isSelected = selectedPeriod == period;

    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: FilterChip(
        label: Text(
          period.toUpperCase(),
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            onPeriodChanged(period);
          }
        },
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedColor: AppTheme.lightTheme.colorScheme.primary,
        checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
        side: BorderSide(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
