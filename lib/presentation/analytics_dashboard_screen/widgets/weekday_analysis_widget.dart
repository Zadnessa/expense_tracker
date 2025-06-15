import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class WeekdayAnalysisWidget extends StatelessWidget {
  final Map<String, double> weekdayData;
  final String currency;

  const WeekdayAnalysisWidget({
    super.key,
    required this.weekdayData,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final maxAmount = weekdayData.values.reduce((a, b) => a > b ? a : b);
    final weekendAverage =
        (weekdayData['Суббота']! + weekdayData['Воскресенье']!) / 2;
    final weekdayAverage = weekdayData.entries
            .where((entry) => !['Суббота', 'Воскресенье'].contains(entry.key))
            .map((entry) => entry.value)
            .reduce((a, b) => a + b) /
        5;

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
          Text('Будни vs Выходные',
              style: AppTheme.lightTheme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 16),

          // Comparison Cards
          Row(children: [
            Expanded(
                child:
                    _buildComparisonCard('Будни', weekdayAverage, Colors.blue)),
            SizedBox(width: 12),
            Expanded(
                child: _buildComparisonCard(
                    'Выходные', weekendAverage, Colors.orange)),
          ]),

          SizedBox(height: 16),

          // Bar Chart
          SizedBox(
              height: 200,
              child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxAmount * 1.2,
                  barTouchData: BarTouchData(touchTooltipData:
                      BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final dayName = weekdayData.keys.elementAt(group.x.toInt());
                    return BarTooltipItem(
                        '$dayName\n${_formatAmount(rod.toY)} $currency',
                        AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.primary));
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
                                final dayName =
                                    weekdayData.keys.elementAt(value.toInt());
                                return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(dayName.substring(0, 2),
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
                  barGroups: weekdayData.entries.map((entry) {
                    final index = weekdayData.keys.toList().indexOf(entry.key);
                    final isWeekend =
                        ['Суббота', 'Воскресенье'].contains(entry.key);

                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(
                          toY: entry.value,
                          color: isWeekend ? Colors.orange : Colors.blue,
                          width: 16,
                          borderRadius: BorderRadius.circular(4)),
                    ]);
                  }).toList()))),
        ]));
  }

  Widget _buildComparisonCard(String title, double amount, Color color) {
    return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: AppTheme.lightTheme.textTheme.bodySmall
                  ?.copyWith(color: color, fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text('${_formatAmount(amount)} $currency',
              style: AppTheme.lightTheme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700, color: color)),
        ]));
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
