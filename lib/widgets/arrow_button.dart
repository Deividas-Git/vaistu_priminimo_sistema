import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  const ArrowButton({super.key, required this.onButtonPressed});

  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onButtonPressed,
      icon: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorScheme.of(context).primary,
        ),
        child: SizedBox(
          height: 50,
          width: 50,
          child: Icon(Icons.arrow_forward, color: Colors.white),
        ),
      ),
    );
  }
}
