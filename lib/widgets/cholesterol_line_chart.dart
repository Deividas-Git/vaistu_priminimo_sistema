import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/helpers/date_helper.dart';
import 'package:vaistu_priminimo_sistema/models/health_metric/health_metric.dart';

class CholesterolLineChart extends StatelessWidget {
  final List<HealthMetric> metrics;

  const CholesterolLineChart({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    final sorted = [...metrics]
      ..sort((a, b) => a.dateMeasured.compareTo(b.dateMeasured));

    final spots = List.generate(sorted.length, (index) {
      return FlSpot(index.toDouble(), sorted[index].value);
    });

    return Padding(
      padding: const EdgeInsets.only(right: 30.0, left: 5.0),
      child: SizedBox(
        height: 250,
        child: LineChart(
          LineChartData(
            minY: 0,
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: true),

            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) {
                    int i = value.toInt();
                    if (i < 0 || i >= sorted.length) {
                      return const SizedBox();
                    }
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(
                        DateHelper.getFormattedDate(sorted[i].dateMeasured),
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

            lineBarsData: [
              LineChartBarData(
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
