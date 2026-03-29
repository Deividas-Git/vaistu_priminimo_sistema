import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class AdherenceBar extends StatelessWidget {
  const AdherenceBar({super.key, required this.percentage});
  final double percentage;

  Color _getColor() {
    if (percentage >= 80) return const Color.fromARGB(255, 58, 172, 62);
    if (percentage >= 50) return const Color.fromARGB(255, 246, 186, 6);
    return const Color.fromARGB(255, 197, 35, 23);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: percentage),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return ThemedContainerWidget(
          doesHeightExpand: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 18,
                    color: ColorScheme.of(context).onSurfaceVariant,
                  ),
                  children: [
                    TextSpan(text: "Vartojimo procentas: "),
                    TextSpan(
                      text: "${value.toInt()}%",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 25,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorScheme.of(context).onSecondaryFixedVariant,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value / 100,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getColor(),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            color: _getColor().withValues(alpha: 0.75),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
