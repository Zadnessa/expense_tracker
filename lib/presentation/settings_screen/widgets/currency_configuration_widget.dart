import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CurrencyConfigurationWidget extends StatelessWidget {
  final String selectedCurrency;
  final double exchangeRate;
  final Function(String, double) onCurrencyChanged;

  const CurrencyConfigurationWidget({
    super.key,
    required this.selectedCurrency,
    required this.exchangeRate,
    required this.onCurrencyChanged,
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
                  iconName: 'currency_exchange',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Валюта',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Текущая валюта',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              subtitle: Text(
                selectedCurrency == '₽'
                    ? 'Российский рубль (₽)'
                    : 'Доллар США (\$)',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedCurrency,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                ],
              ),
              onTap: () => _showCurrencyBottomSheet(context),
            ),
            selectedCurrency == '\$'
                ? Column(
                    children: [
                      Divider(color: AppTheme.lightTheme.dividerColor),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Курс обмена',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          '1 \$ = ${exchangeRate.toStringAsFixed(2)} ₽',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        trailing: CustomIconWidget(
                          iconName: 'edit',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        onTap: () => _showExchangeRateDialog(context),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  void _showCurrencyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.bottomSheetTheme.backgroundColor,
      shape: AppTheme.lightTheme.bottomSheetTheme.shape,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Выберите валюту',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: Text(
                  '₽',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                title: Text(
                  'Российский рубль',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                trailing: selectedCurrency == '₽'
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      )
                    : null,
                onTap: () {
                  onCurrencyChanged('₽', 1.0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Text(
                  '\$',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                title: Text(
                  'Доллар США',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                trailing: selectedCurrency == '\$'
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      )
                    : null,
                onTap: () {
                  onCurrencyChanged('\$', exchangeRate);
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _showExchangeRateDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: exchangeRate.toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.dialogTheme.backgroundColor,
          shape: AppTheme.lightTheme.dialogTheme.shape,
          title: Text(
            'Курс обмена',
            style: AppTheme.lightTheme.dialogTheme.titleTextStyle,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Введите курс обмена USD к RUB',
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
                  labelText: '1 \$ = ? ₽',
                  suffixText: '₽',
                  border: AppTheme.lightTheme.inputDecorationTheme.border,
                  focusedBorder:
                      AppTheme.lightTheme.inputDecorationTheme.focusedBorder,
                ),
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
                final double? newRate = double.tryParse(controller.text);
                if (newRate != null && newRate > 0) {
                  onCurrencyChanged(selectedCurrency, newRate);
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
