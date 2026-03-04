import 'package:flutter/material.dart';

class SelectionTileButtonWidget<T> extends StatelessWidget {
  const SelectionTileButtonWidget({
    super.key,
    required this.isSelected,
    required this.label,
    required this.value,
    required this.onTap,
  });
  final bool isSelected;
  final String label;
  final T value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: ColorScheme.of(context).secondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(5),
        highlightColor: ColorScheme.of(
          context,
        ).secondary.withValues(alpha: 0.35),
        onTap: onTap,
        child: Ink(
          // width: 40,
          // height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isSelected
                ? ColorScheme.of(context).primary.withValues(alpha: 0.85)
                : ColorScheme.of(context).surface,
          ),
          child: Center(
            child: Text(
              label,
              style: isSelected
                  ? TextStyle(color: Colors.white)
                  : TextStyle(color: ColorScheme.of(context).secondary),
            ),
          ),
        ),
      ),
    );
  }
}
