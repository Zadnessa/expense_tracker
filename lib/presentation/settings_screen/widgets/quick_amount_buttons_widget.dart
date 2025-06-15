import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class QuickAmountButtonsWidget extends StatefulWidget {
  final List<double> quickAmounts;
  final Function(List<double>) onQuickAmountsChanged;

  const QuickAmountButtonsWidget({
    super.key,
    required this.quickAmounts,
    required this.onQuickAmountsChanged,
  });

  @override
  State<QuickAmountButtonsWidget> createState() =>
      _QuickAmountButtonsWidgetState();
}

class _QuickAmountButtonsWidgetState extends State<QuickAmountButtonsWidget> {
  late List<double> _amounts;
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _amounts = List.from(widget.quickAmounts);
  }

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
                  iconName: 'speed',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Быстрые суммы',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Настройте кнопки для быстрого ввода сумм',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            SizedBox(height: 2.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: List.generate(_amounts.length, (index) {
                return _buildAmountChip(index);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountChip(int index) {
    final amount = _amounts[index];
    final formattedAmount = _formatAmount(amount);

    return GestureDetector(
      onTap: () => _editAmount(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formattedAmount,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)} тыс ₽';
    }
    return '${amount.toStringAsFixed(amount % 1 == 0 ? 0 : 1)} ₽';
  }

  void _editAmount(int index) {
    final TextEditingController controller = TextEditingController(
      text: _amounts[index].toStringAsFixed(_amounts[index] % 1 == 0 ? 0 : 1),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.dialogTheme.backgroundColor,
          shape: AppTheme.lightTheme.dialogTheme.shape,
          title: Text(
            'Изменить сумму',
            style: AppTheme.lightTheme.dialogTheme.titleTextStyle,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Введите новую сумму для быстрой кнопки',
                style: AppTheme.lightTheme.dialogTheme.contentTextStyle,
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  labelText: 'Сумма',
                  suffixText: '₽',
                  border: AppTheme.lightTheme.inputDecorationTheme.border,
                  focusedBorder:
                      AppTheme.lightTheme.inputDecorationTheme.focusedBorder,
                ),
                autofocus: true,
              ),
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
            TextButton(
              onPressed: () {
                final double? newAmount = double.tryParse(controller.text);
                if (newAmount != null && newAmount > 0) {
                  setState(() {
                    _amounts[index] = newAmount;
                  });
                  widget.onQuickAmountsChanged(_amounts);
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Сохранить',
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
