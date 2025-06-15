import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/app_export.dart';

class MonthlyComparisonChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> monthlyData;
  final String currency;

  const MonthlyComparisonChartWidget({
    super.key,
    required this.monthlyData,
    required this.currency,
  });

  @override
  State<MonthlyComparisonChartWidget> createState() =>
      _MonthlyComparisonChartWidgetState();
}

class _MonthlyComparisonChartWidgetState
    extends State<MonthlyComparisonChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final maxAmount = widget.monthlyData.fold<double>(
        0.0,
        (max, item) =>
            (item['amount'] as double) > max ? item['amount'] as double : max);

    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Помесячное сравнение',
                style: AppTheme.lightTheme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            if (touchedIndex >= 0)
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                      '${widget.monthlyData[touchedIndex]['month']}: ${_formatAmount(widget.monthlyData[touchedIndex]['amount'] as double)} ${widget.currency}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary))),
          ]),
          SizedBox(height: 16),
          SizedBox(
              height: 200,
              child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxAmount * 1.2,
                  barTouchData: BarTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              barTouchResponse == null ||
                              barTouchResponse.spot == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex =
                              barTouchResponse.spot!.touchedBarGroupIndex;
                          HapticFeedback.lightImpact();
                        });
                      },
                      touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final monthData = widget.monthlyData[group.x.toInt()];
                        return BarTooltipItem(
                            '${monthData['month']}\n${_formatAmount(rod.toY)} ${widget.currency}',
                            AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    AppTheme.lightTheme.colorScheme.primary));
                      })),
                  titlesData: FlTitlesData(
                      show: true,
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                final monthData =
                                    widget.monthlyData[value.toInt()];
                                return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                        (monthData['month'] as String)
                                            .substring(0, 3),
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                                color: AppTheme
                                                    .lightTheme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                                fontSize: 10)));
                              })),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: maxAmount / 4,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(_formatAmount(value),
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurfaceVariant,
                                            fontSize: 10));
                              }))),
                  borderData: FlBorderData(
                      show: true,
                      border: Border(
                          bottom: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                              width: 1),
                          left: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                              width: 1))),
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxAmount / 4,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1);
                      }),
                  barGroups: widget.monthlyData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    final isTouched = index == touchedIndex;

                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(
                          toY: data['amount'] as double,
                          color: isTouched
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.7),
                          width: isTouched ? 20 : 16,
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                              colors: [
                                AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.8),
                                AppTheme.lightTheme.colorScheme.primary,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter)),
                    ]);
                  }).toList()))),
          SizedBox(height: 16),

          // Summary Statistics
          Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surfaceContainer
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                        'Среднее',
                        _calculateAverage(),
                        CustomIconWidget(
                            iconName: 'trending_flat',
                            size: 16,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant)),
                    Container(
                        width: 1,
                        height: 30,
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3)),
                    _buildStatItem(
                        'Максимум',
                        maxAmount,
                        CustomIconWidget(
                            iconName: 'trending_up',
                            size: 16,
                            color: Colors.green)),
                    Container(
                        width: 1,
                        height: 30,
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3)),
                    _buildStatItem(
                        'Минимум',
                        _calculateMinimum(),
                        CustomIconWidget(
                            iconName: 'trending_down',
                            size: 16,
                            color: Colors.red)),
                  ])),
        ]));
  }

  Widget _buildStatItem(String label, double value, Widget icon) {
    return Column(children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        icon,
        SizedBox(width: 4),
        Text(label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 10)),
      ]),
      SizedBox(height: 2),
      Text('${_formatAmount(value)} ${widget.currency}',
          style: AppTheme.lightTheme.textTheme.bodySmall
              ?.copyWith(fontWeight: FontWeight.w600, fontSize: 11)),
    ]);
  }

  double _calculateAverage() {
    final total = widget.monthlyData
        .fold<double>(0.0, (sum, item) => sum + (item['amount'] as double));
    return total / widget.monthlyData.length;
  }

  double _calculateMinimum() {
    return widget.monthlyData.fold<double>(
        double.infinity,
        (min, item) =>
            (item['amount'] as double) < min ? item['amount'] as double : min);
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}М';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}К';
    }
    return amount.toStringAsFixed(0);
  }
}
