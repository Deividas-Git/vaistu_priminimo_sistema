import 'package:flutter/material.dart';

class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({super.key, required this.controller});

  final TextEditingController controller;

  void _onSend(BuildContext context) {
    Navigator.pop(context, true);
  }

  void _onCancel(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: Center(child: Text("Slaptažodžio atstatymas")),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          labelText: "Įveskite el. paštą",
          hintText: "El. paštas",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => _onCancel(context),
          child: Text("Atšaukti"),
        ),
        ElevatedButton(
          onPressed: () => _onSend(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorScheme.of(context).primary,
          ),
          child: Text(
            "Siųsti",
            style: TextStyle(color: ColorScheme.of(context).onPrimary),
          ),
        ),
      ],
    );
  }
}
