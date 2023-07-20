import 'package:flutter/material.dart';
import 'package:hendrix_today_uploader/objects/upload_item.dart';

enum _CanConstructMap {
  yes,
  missingFields,
  invalidIndicies,
  duplicateIndicies;

  String get errorMessage => switch (this) {
        missingFields =>
          'Not all required fields have been given a column number.',
        invalidIndicies => 'An invalid column number was used.',
        duplicateIndicies =>
          'The same column number was used for multiple fields.',
        _ => '',
      };
}

class ColumnSelector extends StatelessWidget {
  ColumnSelector({super.key, required this.columnCount});
  final int columnCount;

  final TextEditingController idController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController beginController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locController = TextEditingController();
  final TextEditingController applyController = TextEditingController();

  bool _isValidColumnIndex(TextEditingController tec) {
    final parse = int.tryParse(tec.text);
    if (parse == null) return false;
    return parse >= 0 && parse < columnCount;
  }

  _CanConstructMap _canConstructMap() {
    final requiredControllers = [
      idController,
      titleController,
      descController,
      typeController,
      nameController,
      emailController,
      beginController,
      endController,
    ];
    final allControllers = [
      ...requiredControllers,
      dateController,
      timeController,
      locController,
      applyController,
    ];
    final allControllersWithText =
        allControllers.where((tec) => tec.text.isNotEmpty);

    // Required fields must be mapped
    if (requiredControllers.any((tec) => tec.text.isEmpty)) {
      return _CanConstructMap.missingFields;
    }
    // All used fields must be valid indicies
    if (allControllers
        .any((tec) => tec.text.isNotEmpty && !_isValidColumnIndex(tec))) {
      return _CanConstructMap.invalidIndicies;
    }
    // Don't allow duplicate column indicies
    if (Set.of(allControllersWithText.map((tec) => tec.text)).length <
        allControllersWithText.length) {
      return _CanConstructMap.duplicateIndicies;
    }
    return _CanConstructMap.yes;
  }

  ExcelFieldMap _constructMap() => ExcelFieldMap(
        id: int.parse(idController.text),
        title: int.parse(titleController.text),
        description: int.parse(descController.text),
        type: int.parse(typeController.text),
        contactName: int.parse(nameController.text),
        contactEmail: int.parse(emailController.text),
        beginPosting: int.parse(beginController.text),
        endPosting: int.parse(endController.text),
        date: int.parse(dateController.text),
        time: int.parse(timeController.text),
        location: int.parse(locController.text),
        applyDeadline: int.parse(applyController.text),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Columns'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'List the column number (the first row of the table) for each '
                'column name below.'),
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                  labelText: 'Description (with embedded links)'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(
                  labelText: 'Type ("Event", "Meeting", etc.)'),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Contact name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Contact email'),
            ),
            TextField(
              controller: beginController,
              decoration:
                  const InputDecoration(labelText: 'Date to begin posting'),
            ),
            TextField(
              controller: endController,
              decoration: const InputDecoration(labelText: 'Last day to post'),
            ),
            TextField(
              controller: dateController,
              decoration:
                  const InputDecoration(labelText: 'Event date (optional)'),
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Time (optional)'),
            ),
            TextField(
              controller: locController,
              decoration:
                  const InputDecoration(labelText: 'Location (optional)'),
            ),
            TextField(
              controller: applyController,
              decoration:
                  const InputDecoration(labelText: 'Deadline date (optional)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final canConstruct = _canConstructMap();
            if (canConstruct == _CanConstructMap.yes) {
              Navigator.pop(context, _constructMap());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  content: Text(canConstruct.errorMessage)));
            }
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
