import 'package:flutter/material.dart';

class AmountButton extends StatelessWidget {
  const AmountButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.isDisabled,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool? isDisabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: ColorScheme.of(context).primary.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(5),
        highlightColor: ColorScheme.of(
          context,
        ).secondary.withValues(alpha: 0.35),
        onTap: isDisabled == true ? null : onTap,
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDisabled == true
                ? ColorScheme.of(context).secondary
                : ColorScheme.of(context).primary.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Icon(
            icon,
            color: isDisabled == true
                ? ColorScheme.of(context).onSecondary.withValues(alpha: 0.5)
                : ColorScheme.of(context).onPrimary,
          ),
        ),
      ),
    );
  }
}
