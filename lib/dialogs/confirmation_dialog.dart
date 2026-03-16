import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.message,
    required this.title,
    required this.rightOptionText,
    required this.leftOptionText,
    this.rightSideHighlighted,
    this.leftSideHighlighted,
  });

  final String message;
  final String title;
  final String rightOptionText;
  final String leftOptionText;
  final bool? rightSideHighlighted;
  final bool? leftSideHighlighted;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        OptionButton(
          isHighlighted: leftSideHighlighted,
          text: leftOptionText,
          result: false,
        ),
        OptionButton(
          isHighlighted: rightSideHighlighted,
          text: rightOptionText,
          result: true,
        ),
      ],
    );
  }
}

class OptionButton extends StatelessWidget {
  const OptionButton({
    super.key,
    required this.isHighlighted,
    required this.text,
    required this.result,
  });

  final bool? isHighlighted;
  final String text;
  final bool result;

  ButtonStyle highlightButton(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: ColorScheme.of(context).primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context, result),
      style: isHighlighted == true ? highlightButton(context) : null,
      child: Text(
        text,
        style: isHighlighted == true ? TextStyle(color: Colors.white) : null,
      ),
    );
  }
}
