import 'package:flutter/material.dart';

import 'package:hendrix_today_uploader/firebase/download.dart';
import 'package:hendrix_today_uploader/firebase/constants.dart';
import 'package:hendrix_today_uploader/firebase/upload.dart';
import 'package:hendrix_today_uploader/widgets/table_item.dart';
import 'package:hendrix_today_uploader/widgets/table_scroller.dart';

class DatabaseViewScreen extends StatefulWidget {
  const DatabaseViewScreen({super.key});

  @override
  State<DatabaseViewScreen> createState() => _DatabaseViewScreenState();
}

class _DatabaseViewScreenState extends State<DatabaseViewScreen> {
  List<FirestoreRow>? _items;
  bool _deleteInProgress = false;

  @override
  void initState() {
    super.initState();
    _getFirestoreContents();
  }

  void _getFirestoreContents() async {
    final items = await getFirestoreContents();
    if (mounted) {
      setState(() {
        _items = items;
      });
    }
  }

  void _tryDeleteOldEvents() async {
    if (_deleteInProgress) return;
    if (_items == null) return;
    if (mounted) {
      setState(() {
        _deleteInProgress = true;
      });
    }
    final today = DateTime.now();
    final oldItems = _items!
        .where((row) => undoFormatDate(row[7])?.isBefore(today) ?? false);
    final deleteResults = <UploadResult>[];
    for (final item in oldItems) {
      deleteResults.add(await deleteFromFirestore(item));
      if (deleteResults.last.type == UploadResultType.permissionDenied) break;
    }
    if (mounted) {
      setState(() {
        _deleteInProgress = false;
      });
    }
    _displayDeleteResults(deleteResults);
    _getFirestoreContents();
  }

  /// Displays [SnackBar] messages for each [UploadResultType] in [results].
  ///
  /// This method lives outside the [_tryDeleteOldEvents] method because
  /// [BuildContext]s cannot be used in `async` methods.
  void _displayDeleteResults(List<UploadResult> results) {
    if (results
        .any((result) => result.type == UploadResultType.permissionDenied)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
            'You do not have delete permission. Please sign in or contact the '
            'maintainer of this upload tool.'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      return;
    }
    final invalidFields = results
        .where((result) => result.type == UploadResultType.invalidFields);
    if (invalidFields.isNotEmpty) {
      String displayIDs = invalidFields
          .map((result) => result.snapshot[idField.index] ?? '[missing ID]')
          .join(', ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'The following rows (by ID) are improperly formatted or missing '
            'required data: $displayIDs'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
    final idsNotPresent =
        results.where((result) => result.type == UploadResultType.idNotPresent);
    if (idsNotPresent.isNotEmpty) {
      String displayIDs = idsNotPresent
          .map((result) => result.snapshot[idField.index])
          .join(', ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'The following rows (by ID) could not be deleted because their IDs '
            'are not present in the database: $displayIDs'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
    final unknownErrors =
        results.where((result) => result.type == UploadResultType.unknownError);
    if (unknownErrors.isNotEmpty) {
      String displayIDs = unknownErrors
          .map((result) => result.snapshot[idField.index])
          .join(', ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'An unknown error occurred trying to delete the following rows (by '
            'ID): $displayIDs'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
    final successfulDeletes = results
        .where((result) => result.type == UploadResultType.successfulDelete);
    if (successfulDeletes.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully deleted ${successfulDeletes.length} '
            'item${successfulDeletes.length != 1 ? 's' : ''}!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Database"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_items != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 10),
                child: Row(
                  children: [
                    Text('There are ${_items!.length} items in the database.'),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _tryDeleteOldEvents,
                      child: _deleteInProgress
                          ? const Text('Deleting...')
                          : const Text('Delete all old events'),
                    ),
                  ],
                ),
              ),
            if (_items == null)
              const Center(child: Text('Loading...'))
            else
              TableScroller(
                child: Table(
                  border: TableBorder.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  children: [
                    TableRow(
                        children: orderedFields
                            .map((field) => Center(
                                  child: TableItem(
                                    cellValue: field.name,
                                  ),
                                ))
                            .toList()),
                    ..._items!.map((row) => TableRow(
                          children: row
                              .map((item) => TableItem(
                                    cellValue: item,
                                    maxLength: 40,
                                  ))
                              .toList(),
                        ))
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
