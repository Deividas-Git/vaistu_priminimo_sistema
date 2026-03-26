import 'package:flutter/material.dart';

class ThemedContainerWidget extends StatelessWidget {
  const ThemedContainerWidget({
    super.key,
    this.height,
    this.doesHeightExpand,
    required this.child,
  });
  final double? height;
  final Widget child;
  final bool? doesHeightExpand;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: doesHeightExpand == true
          ? null
          : height ?? 55, //55 default dydis atitinkantis textField
      child: Container(
        decoration: BoxDecoration(
          color: ColorScheme.of(context).secondaryContainer,
          border: BoxBorder.all(color: ColorScheme.of(context).secondary),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(padding: const EdgeInsets.all(8.0), child: child),
      ),
    );
  }
}
