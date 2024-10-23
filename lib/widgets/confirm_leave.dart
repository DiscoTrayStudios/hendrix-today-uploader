import 'package:flutter/material.dart';

class ConfirmLeaveDialog extends StatelessWidget {
  const ConfirmLeaveDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Discard Changes"),
      content: const Text(
        "Leaving the page will cause any changes not saved to the database to "
        "be lost. Are you sure you want to leave?",
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("No, stay here"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Yes, discard changes and leave"),
          ),
        ),
      ],
    );
  }
}