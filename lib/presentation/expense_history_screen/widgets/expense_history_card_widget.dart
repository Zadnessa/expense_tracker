import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExpenseHistoryCardWidget extends StatelessWidget {
  final Map<String, dynamic> expense;
  final bool isSelected;
  final bool isMultiSelectMode;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onSelected;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseHistoryCardWidget({
    super.key,
    required this.expense,
    required this.isSelected,
    required this.isMultiSelectMode,
    required this.onLongPress,
    required this.onSelected,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Dismissible(
        key: Key('expense_${expense['id']}'),
        background: _buildSwipeBackground(isEdit: true),
        secondaryBackground: _buildSwipeBackground(isEdit: false),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            onEdit();
          } else {
            onDelete();
          }
        },
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            return await _showDeleteConfirmation(context);
          }
          return false; // Don't dismiss for edit, just trigger action
        },
        child: GestureDetector(
          onLongPress: isMultiSelectMode ? null : onLongPress,
          onTap: isMultiSelectMode ? () => onSelected(!isSelected) : null,
          child: Card(
            elevation: isSelected ? 4 : 1,
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primaryContainer
                : AppTheme.lightTheme.cardColor,
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  if (isMultiSelectMode) ...[
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) => onSelected(value ?? false),
                    ),
                    SizedBox(width: 2.w),
                  ],
                  _buildCategoryIndicator(),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildExpenseDetails(),
                  ),
                  _buildAmountSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isEdit}) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: isEdit
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.lightTheme.colorScheme.error,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: isEdit ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: isEdit ? 'edit' : 'delete',
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isEdit ? 'Изменить' : 'Удалить',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIndicator() {
    return Container(
      width: 4,
      height: 6.h,
      decoration: BoxDecoration(
        color: expense['categoryColor'] as Color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildExpenseDetails() {
    final DateTime date = expense['date'] as DateTime;
    final String formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              expense['category'] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            if (expense['isIrregular'] as bool) ...[
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Нерегулярный',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          expense['subcategory'] as String,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          formattedDate,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (expense['notes'] != null &&
            (expense['notes'] as String).isNotEmpty) ...[
          SizedBox(height: 0.5.h),
          Text(
            expense['notes'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildAmountSection() {
    final double amount = expense['amount'] as double;
    final String currency = expense['currency'] as String;
    final String formattedAmount =
        NumberFormat('#,##0.00', 'ru_RU').format(amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$formattedAmount $currency',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 0.5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: (expense['categoryColor'] as Color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            expense['category'] as String,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: expense['categoryColor'] as Color,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    HapticFeedback.mediumImpact();

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Удалить расход?'),
            content: const Text('Это действие нельзя отменить.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
                child: const Text('Удалить'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
