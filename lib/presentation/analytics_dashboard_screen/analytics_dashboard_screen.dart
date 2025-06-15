import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import './widgets/daily_spending_chart_widget.dart';
import './widgets/expense_pie_chart_widget.dart';
import './widgets/export_menu_widget.dart';
import './widgets/month_comparison_card_widget.dart';
import './widgets/monthly_comparison_chart_widget.dart';
import './widgets/period_selector_widget.dart';
import './widgets/weekday_analysis_widget.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  String selectedPeriod = 'месяц';
  String selectedCurrency = '₽';
  bool isLoading = false;

  // Mock data for analytics
  final List<Map<String, dynamic>> mockExpenseData = [
    {
      "category": "Продукты",
      "amount": 15000.0,
      "color": Color(0xFF4CAF50),
      "percentage": 35.0,
    },
    {
      "category": "Транспорт",
      "amount": 8500.0,
      "color": Color(0xFF2196F3),
      "percentage": 20.0,
    },
    {
      "category": "Питание вне дома",
      "amount": 7200.0,
      "color": Color(0xFFFF9800),
      "percentage": 17.0,
    },
    {
      "category": "Развлечения",
      "amount": 5800.0,
      "color": Color(0xFF9C27B0),
      "percentage": 13.5,
    },
    {
      "category": "Здоровье",
      "amount": 4200.0,
      "color": Color(0xFFF44336),
      "percentage": 10.0,
    },
    {
      "category": "Прочее",
      "amount": 2000.0,
      "color": Color(0xFF424242),
      "percentage": 4.5,
    },
  ];

  final List<Map<String, dynamic>> monthComparisonData = [
    {
      "currentMonth": "Декабрь",
      "currentAmount": 42700.0,
      "previousAmount": 38500.0,
      "percentageChange": 10.9,
      "isIncrease": true,
    },
    {
      "currentMonth": "Ноябрь",
      "currentAmount": 38500.0,
      "previousAmount": 41200.0,
      "percentageChange": -6.6,
      "isIncrease": false,
    },
  ];

  final List<Map<String, dynamic>> dailySpendingData = [
    {"day": 1, "amount": 1200.0},
    {"day": 2, "amount": 850.0},
    {"day": 3, "amount": 2100.0},
    {"day": 4, "amount": 950.0},
    {"day": 5, "amount": 1800.0},
    {"day": 6, "amount": 2500.0},
    {"day": 7, "amount": 3200.0},
    {"day": 8, "amount": 1100.0},
    {"day": 9, "amount": 1650.0},
    {"day": 10, "amount": 2200.0},
    {"day": 11, "amount": 1400.0},
    {"day": 12, "amount": 1900.0},
    {"day": 13, "amount": 2800.0},
    {"day": 14, "amount": 3500.0},
    {"day": 15, "amount": 1300.0},
  ];

  final Map<String, double> weekdayData = {
    "Понедельник": 1200.0,
    "Вторник": 1100.0,
    "Среда": 1350.0,
    "Четверг": 1250.0,
    "Пятница": 1800.0,
    "Суббота": 2500.0,
    "Воскресенье": 2200.0,
  };

  final List<Map<String, dynamic>> monthlyComparisonData = [
    {"month": "Июль", "amount": 35200.0},
    {"month": "Август", "amount": 38900.0},
    {"month": "Сентябрь", "amount": 41500.0},
    {"month": "Октябрь", "amount": 39800.0},
    {"month": "Ноябрь", "amount": 38500.0},
    {"month": "Декабрь", "amount": 42700.0},
  ];

  void _onPeriodChanged(String period) {
    setState(() {
      selectedPeriod = period;
      isLoading = true;
    });

    // Simulate data loading
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void _onCurrencyChanged(String currency) {
    setState(() {
      selectedCurrency = currency;
    });
    HapticFeedback.lightImpact();
  }

  void _onExportData() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Экспорт данных начат...'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Sticky Header
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 0,
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            elevation: 1,
            surfaceTintColor: AppTheme.lightTheme.colorScheme.primary,
            title: Text(
              'Аналитика',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              ExportMenuWidget(
                onExport: _onExportData,
              ),
              SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: PeriodSelectorWidget(
                        selectedPeriod: selectedPeriod,
                        onPeriodChanged: _onPeriodChanged,
                      ),
                    ),
                    SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildCurrencyButton('₽'),
                          _buildCurrencyButton('\$'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: isLoading ? _buildLoadingState() : _buildAnalyticsContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyButton(String currency) {
    final isSelected = selectedCurrency == currency;
    return GestureDetector(
      onTap: () => _onCurrencyChanged(currency),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          currency,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Skeleton for pie chart
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          SizedBox(height: 24),

          // Skeleton for comparison cards
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Skeleton for daily chart
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsContent() {
    final hasData = mockExpenseData.isNotEmpty;

    if (!hasData) {
      return _buildEmptyState();
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Expense Distribution Pie Chart
          ExpensePieChartWidget(
            expenseData: mockExpenseData,
            currency: selectedCurrency,
          ),
          SizedBox(height: 24),

          // Month-over-Month Comparison
          Text(
            'Сравнение по месяцам',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: monthComparisonData.map((data) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: monthComparisonData.indexOf(data) == 0 ? 8 : 0,
                    left: monthComparisonData.indexOf(data) == 1 ? 8 : 0,
                  ),
                  child: MonthComparisonCardWidget(
                    data: data,
                    currency: selectedCurrency,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 24),

          // Daily Spending Dynamics
          Text(
            'Динамика трат по дням',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          DailySpendingChartWidget(
            dailyData: dailySpendingData,
            currency: selectedCurrency,
          ),
          SizedBox(height: 24),

          // Weekday vs Weekend Analysis
          Text(
            'Анализ по дням недели',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          WeekdayAnalysisWidget(
            weekdayData: weekdayData,
            currency: selectedCurrency,
          ),
          SizedBox(height: 24),

          // Monthly Comparison Chart
          Text(
            'Сравнение за 6 месяцев',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          MonthlyComparisonChartWidget(
            monthlyData: monthlyComparisonData,
            currency: selectedCurrency,
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'analytics',
            size: 64,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.5),
          ),
          SizedBox(height: 16),
          Text(
            'Недостаточно данных',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Добавьте больше расходов для просмотра аналитики',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/expense-entry-screen');
            },
            child: Text('Добавить расход'),
          ),
        ],
      ),
    );
  }
}
