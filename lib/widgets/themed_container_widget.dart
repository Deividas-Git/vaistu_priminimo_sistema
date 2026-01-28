import 'package:flutter/material.dart';

class ThemedContainerWidget extends StatelessWidget {
  const ThemedContainerWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: Container(
        decoration: BoxDecoration(
          color: ColorScheme.of(context).inversePrimary.withValues(alpha: 0.8),
          border: BoxBorder.all(color: ColorScheme.of(context).primary),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(padding: const EdgeInsets.all(8.0), child: child),
      ),
    );
  }
}
