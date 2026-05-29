import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/chart_data.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class ConsumptionProgressPieChart extends StatefulWidget {
  const ConsumptionProgressPieChart({super.key, required this.data});

  final List<ChartData> data;

  @override
  State<ConsumptionProgressPieChart> createState() =>
      _ConsumptionProgressPieChartState();
}

class _ConsumptionProgressPieChartState
    extends State<ConsumptionProgressPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 175,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 50,
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          response.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sections: List.generate(widget.data.length, (i) {
                  final bool isTouched = i == touchedIndex;
                  final ChartData item = widget.data[i];

                  return PieChartSectionData(
                    value: item.value.toDouble(),
                    color: item.color.withValues(alpha: 0.75),
                    radius: isTouched ? 40 : 30,
                    title: item.value.toString(),
                    titleStyle: TextStyle(
                      fontSize: isTouched ? 20 : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
              ),
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOutQuad,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: ThemedContainerWidget(
            doesHeightExpand: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                widget.data.length,
                (int i) => _ChartLegendTile(data: widget.data[i]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChartLegendTile extends StatelessWidget {
  const _ChartLegendTile({required this.data});

  final ChartData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(height: 10, width: 10, color: data.color),
          SizedBox(width: 5),
          Text(
            data.label,
            style: TextStyle(
              fontSize: 14,
              color: ColorScheme.of(context).onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
