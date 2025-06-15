import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DailySpendingChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> dailyData;
  final String currency;

  const DailySpendingChartWidget({
    super.key,
    required this.dailyData,
    required this.currency,
  });

  @override
  State<DailySpendingChartWidget> createState() =>
      _DailySpendingChartWidgetState();
}

class _DailySpendingChartWidgetState extends State<DailySpendingChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
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
            Text('Ежедневные траты',
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
                      '${widget.dailyData[touchedIndex]['day']} день: ${_formatAmount(widget.dailyData[touchedIndex]['amount'] as double)} ${widget.currency}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary))),
          ]),
          SizedBox(height: 16),
          SizedBox(
              height: 200,
              child: LineChart(LineChartData(
                  lineTouchData: LineTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event,
                          LineTouchResponse? touchResponse) {
                        if (event is FlTapUpEvent && touchResponse != null) {
                          final spot = touchResponse.lineBarSpots?.first;
                          if (spot != null) {
                            setState(() {
                              touchedIndex = spot.x.toInt();
                            });
                            HapticFeedback.lightImpact();
                          }
                        }
                      },
                      touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          return LineTooltipItem(
                              '${_formatAmount(barSpot.y)} ${widget.currency}',
                              AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary));
                        }).toList();
                      })),
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _getMaxAmount() / 4,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1);
                      }),
                  titlesData: FlTitlesData(
                      show: true,
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 2,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(value.toInt().toString(),
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
                              interval: _getMaxAmount() / 4,
                              reservedSize: 40,
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
                  minX: 1,
                  maxX: widget.dailyData.length.toDouble(),
                  minY: 0,
                  maxY: _getMaxAmount() * 1.1,
                  lineBarsData: [
                    LineChartBarData(
                        spots: widget.dailyData.asMap().entries.map((entry) {
                          return FlSpot((entry.key + 1).toDouble(),
                              entry.value['amount'] as double);
                        }).toList(),
                        isCurved: true,
                        curveSmoothness: 0.3,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                  radius: index == touchedIndex ? 6 : 4,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  strokeWidth: 2,
                                  strokeColor:
                                      AppTheme.lightTheme.colorScheme.surface);
                            }),
                        belowBarData: BarAreaData(
                            show: true,
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1))),
                  ]))),
        ]));
  }

  double _getMaxAmount() {
    return widget.dailyData.fold<double>(
        0.0,
        (max, item) =>
            (item['amount'] as double) > max ? item['amount'] as double : max);
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
