import 'package:flutter/material.dart';

class ConfirmUploadDialog extends StatelessWidget {
  const ConfirmUploadDialog({
    super.key,
    required this.editCount,
    required this.deleteCount,
  });
  final int editCount;
  final int deleteCount;

  @override
  Widget build(BuildContext context) {
    final String deleteStr = "$deleteCount event${deleteCount == 1 ? '' : 's'}";
    final String editStr= "$editCount event${editCount == 1 ? '' : 's'}";
    return AlertDialog(
      title: const Text("Confirm Changes"),
      content: Text(
        "If you upload the current changes, $deleteStr will be deleted and "
        "$editStr will be edited. Are you sure you want to continue?"
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("No, go back"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Yes, upload changes"),
          ),
        ),
      ],
    );
  }
}