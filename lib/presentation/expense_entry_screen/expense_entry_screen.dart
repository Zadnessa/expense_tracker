import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/cancel_action_button_widget.dart';
import './widgets/custom_numeric_keypad_widget.dart';
import './widgets/quick_amount_buttons_widget.dart';

class ExpenseEntryScreen extends StatefulWidget {
  const ExpenseEntryScreen({super.key});

  @override
  State<ExpenseEntryScreen> createState() => _ExpenseEntryScreenState();
}

class _ExpenseEntryScreenState extends State<ExpenseEntryScreen>
    with TickerProviderStateMixin {
  String _currentAmount = '0';
  bool _isIrregularExpense = false;
  bool _showCancelButton = false;
  late AnimationController _cancelButtonController;
  late Animation<double> _cancelButtonAnimation;
  Timer? _cancelButtonTimer;

  // Mock quick amount presets
  final List<double> _quickAmounts = [50.0, 100.0, 200.0, 500.0, 1000.0];

  @override
  void initState() {
    super.initState();
    _cancelButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _cancelButtonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cancelButtonController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _cancelButtonController.dispose();
    _cancelButtonTimer?.cancel();
    super.dispose();
  }

  void _onKeypadInput(String input) {
    setState(() {
      if (input == 'delete') {
        if (_currentAmount.length > 1) {
          _currentAmount =
              _currentAmount.substring(0, _currentAmount.length - 1);
        } else {
          _currentAmount = '0';
        }
      } else if (input == 'clear') {
        _currentAmount = '0';
      } else if (input == ',') {
        if (!_currentAmount.contains(',')) {
          _currentAmount += ',';
        }
      } else {
        if (_currentAmount == '0') {
          _currentAmount = input;
        } else {
          _currentAmount += input;
        }
      }
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _onQuickAmountSelected(double amount) {
    setState(() {
      _currentAmount = _formatAmount(amount);
    });
    HapticFeedback.selectionClick();
  }

  String _formatAmount(double amount) {
    String formatted = amount.toStringAsFixed(2);
    formatted = formatted.replaceAll('.', ',');

    // Add thousand separators
    List<String> parts = formatted.split(',');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '00';

    // Add spaces for thousands
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ' ';
      }
      formattedInteger += integerPart[i];
    }

    return '\$formattedInteger,\$decimalPart';
  }

  double _parseAmount() {
    try {
      String cleanAmount =
          _currentAmount.replaceAll(' ', '').replaceAll(',', '.');
      return double.parse(cleanAmount);
    } catch (e) {
      return 0.0;
    }
  }

  bool _isAmountValid() {
    return _parseAmount() > 0;
  }

  void _onNextPressed() {
    if (_isAmountValid()) {
      // Show success toast
      Fluttertoast.showToast(
        msg: "Сумма введена: \$_currentAmount ₽",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: Colors.white,
      );

      // Show cancel button for 30 seconds
      _showCancelButtonWithTimer();

      // Navigate to category selection
      Navigator.pushNamed(context, '/category-selection-screen');
    }
  }

  void _showCancelButtonWithTimer() {
    setState(() {
      _showCancelButton = true;
    });
    _cancelButtonController.forward();

    _cancelButtonTimer?.cancel();
    _cancelButtonTimer = Timer(const Duration(seconds: 30), () {
      _hideCancelButton();
    });
  }

  void _hideCancelButton() {
    _cancelButtonController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showCancelButton = false;
        });
      }
    });
    _cancelButtonTimer?.cancel();
  }

  void _onCancelLastAction() {
    setState(() {
      _currentAmount = '0';
      _isIrregularExpense = false;
    });
    _hideCancelButton();

    Fluttertoast.showToast(
      msg: "Последнее действие отменено",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.error,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Amount Display Section
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Amount Display
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppTheme
                                .lightTheme.colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Сумма расхода',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                '\$_currentAmount ₽',
                                style: AppTheme
                                    .lightTheme.textTheme.displayMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Irregular Expense Toggle
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme
                                .lightTheme.colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _isIrregularExpense,
                                onChanged: (value) {
                                  setState(() {
                                    _isIrregularExpense = value ?? false;
                                  });
                                  HapticFeedback.selectionClick();
                                },
                                activeColor:
                                    AppTheme.lightTheme.colorScheme.primary,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  'Нерегулярный расход',
                                  style: AppTheme.lightTheme.textTheme.bodyLarge
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 2.h),

                        // Quick Amount Buttons
                        QuickAmountButtonsWidget(
                          amounts: _quickAmounts,
                          onAmountSelected: _onQuickAmountSelected,
                        ),
                      ],
                    ),
                  ),
                ),

                // Keypad and Next Button Section
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Custom Numeric Keypad
                        Expanded(
                          child: CustomNumericKeypadWidget(
                            onInput: _onKeypadInput,
                          ),
                        ),

                        SizedBox(height: 2.h),

                        // Next Button
                        SizedBox(
                          width: double.infinity,
                          height: 6.h,
                          child: ElevatedButton(
                            onPressed: _isAmountValid() ? _onNextPressed : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isAmountValid()
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline,
                              foregroundColor: Colors.white,
                              elevation: _isAmountValid() ? 3 : 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Далее',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Cancel Last Action Button
            if (_showCancelButton)
              AnimatedBuilder(
                animation: _cancelButtonAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: 2.h,
                    right: 4.w,
                    child: Transform.scale(
                      scale: _cancelButtonAnimation.value,
                      child: CancelActionButtonWidget(
                        onPressed: _onCancelLastAction,
                        remainingSeconds: 30,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
