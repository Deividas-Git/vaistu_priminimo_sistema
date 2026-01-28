import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key, required this.onContinuePressed});
  final VoidCallback onContinuePressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(
        width: 250,
        child: FloatingActionButton(
          onPressed: onContinuePressed,
          backgroundColor: ColorScheme.of(context).primary,
          child: Text(
            "Toliau",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
