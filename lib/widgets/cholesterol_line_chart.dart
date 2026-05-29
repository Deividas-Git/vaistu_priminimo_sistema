import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/helpers/date_helper.dart';
import 'package:vaistu_priminimo_sistema/models/health_metric/health_metric.dart';

class CholesterolLineChart extends StatefulWidget {
  final List<HealthMetric> metrics;

  const CholesterolLineChart({super.key, required this.metrics});

  @override
  State<CholesterolLineChart> createState() => _CholesterolLineChartState();
}

class _CholesterolLineChartState extends State<CholesterolLineChart> {
  List<FlSpot> spots = [];
  bool _firstLoad = true;

  void _buildSpots() {
    setState(() {
      spots = List.generate(widget.metrics.length, (index) {
        return FlSpot(index.toDouble(), widget.metrics[index].value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buildSpots();
      _firstLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.metrics.sort((a, b) => a.dateMeasured.compareTo(b.dateMeasured));

    if (_firstLoad == false) {
      _buildSpots();
    }

    final ColorScheme colorScheme = ColorScheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 55.0, left: 5.0),
      child: SizedBox(
        height: 250,
        child: LineChart(
          duration: const Duration(seconds: 1),
          curve: Curves.easeOutSine,
          LineChartData(
            minY:
                widget.metrics.map((metric) => metric.value).reduce(min) - 0.2,
            maxY:
                widget.metrics.map((metric) => metric.value).reduce(max) + 0.2,
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: true),
            backgroundColor: colorScheme.primary.withValues(alpha: 0.125),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) {
                    int i = value.toInt();
                    if (i < 0 || i >= widget.metrics.length) {
                      return const SizedBox();
                    }
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(
                        DateHelper.getFormattedDate(
                          widget.metrics[i].dateMeasured,
                        ),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),

              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 50),
              ),

              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      "${spot.y} mmol/l",
                      TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                color: colorScheme.primary,
                spots: spots,
                isCurved: true,
                barWidth: 3,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
