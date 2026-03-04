import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({
    super.key,
    required this.message,
    required this.title,
  });

  final String message;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, false),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorScheme.of(context).primary,
          ),
          child: const Text('Atšaukti', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Naikinti',
            style: TextStyle(color: Color.fromARGB(255, 161, 31, 22)),
          ),
        ),
      ],
    );
  }
}
