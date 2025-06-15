import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExpenseTypeFilterWidget extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const ExpenseTypeFilterWidget({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  static const List<Map<String, String>> _expenseTypes = [
    {'key': 'все', 'label': 'Все'},
    {'key': 'обычные', 'label': 'Обычные'},
    {'key': 'нерегулярные', 'label': 'Нерегулярные'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'filter_alt',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Text(
            'Тип:',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _expenseTypes
                    .map((type) => _buildTypeChip(type['key']!, type['label']!))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String key, String label) {
    final bool isSelected = selectedType == key;

    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: ChoiceChip(
        label: Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            onTypeChanged(key);
          }
        },
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedColor: AppTheme.lightTheme.colorScheme.primary,
        side: BorderSide(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
