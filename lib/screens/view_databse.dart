import 'package:flutter/material.dart';
import 'package:hendrix_today_uploader/firebase/database_item.dart';

import 'package:hendrix_today_uploader/firebase/download.dart';
import 'package:hendrix_today_uploader/firebase/upload.dart';
import 'package:hendrix_today_uploader/firebase/upload_result.dart';
import 'package:hendrix_today_uploader/widgets/edit_dialog.dart';
import 'package:hendrix_today_uploader/widgets/table_scroller.dart';

class DatabaseViewScreen extends StatefulWidget {
  const DatabaseViewScreen({super.key});

  @override
  State<DatabaseViewScreen> createState() => _DatabaseViewScreenState();
}

class _DatabaseViewScreenState extends State<DatabaseViewScreen> {
  List<DatabaseItem>? _retrievedItems;
  final List<DatabaseItem> _itemsToEdit = List.empty(growable: true);
  final List<DatabaseItem> _itemsToDelete = List.empty(growable: true);
  bool _dbUpdateInProgress = false;

  @override
  void initState() {
    super.initState();
    _getFirestoreContents();
  }

  void _getFirestoreContents() async {
    final items = await getFirestoreContents();
    if (mounted) {
      setState(() {
        _retrievedItems = items;
      });
    }
  }

  /// Given an original item and an edited version, decide whether to add or
  /// remove the edited version to [_itemsToEdit] and whether to add or remove
  /// the original to [_itemsToDelete].
  void _afterEditing(DatabaseItem original, DatabaseItem? editedItem) {
    if (editedItem case DatabaseItem newItem) {
      _itemsToDelete
        .removeWhere((item) =>
          item.id == newItem.id
        );
      _itemsToEdit
        .removeWhere((item) =>
          item.id == newItem.id
        );
      if (!newItem.equals(original)) {
        _itemsToEdit.add(newItem);
      }
    } else {
      if (_markedForDeletion(original)) {
        _itemsToDelete
          .removeWhere((item) =>
            item.id == original.id
          );
      } else {
        _itemsToDelete.add(original);
      }
    }
    print("items to edit: $_itemsToEdit");
    print("items to delete: $_itemsToDelete");
  }

  /// Has an item been marked for editing which has the same ID as [dbItem]?
  bool _markedForEdit(DatabaseItem dbItem) => _itemsToEdit
    .map((item) => item.id)
    .contains(dbItem.id);
  
  /// Has an item been marked for deletion which has the same ID as [dbItem]?
  bool _markedForDeletion(DatabaseItem dbItem) => _itemsToDelete
    .map((item) => item.id)
    .contains(dbItem.id);

  void _markOldEventsToDelete() {
    final today = DateTime.now();
    for (final itemToCheck in _retrievedItems ?? <DatabaseItem>[]) {
      if (itemToCheck.endPosting.isBefore(today)) {
        if (!_itemsToDelete.map((item) => item.id).contains(itemToCheck.id)) {
          _itemsToDelete.add(itemToCheck);
        }
      }
    }
  }

  /// Checks to see if there is a [DatabaseItem] with the same ID as [dbItem]
  /// that has been edited this session. If so, the newer version is returned;
  /// otherwise, the original item is returned.
  DatabaseItem _latestVersion(DatabaseItem dbItem) {
    final editedVersion = _itemsToEdit
      .where((item) => item.id == dbItem.id)
      .firstOrNull;
    return switch (editedVersion) {
      null => dbItem,
      DatabaseItem latestVersion => latestVersion,
    };
  }

  void _applyChanges() async {
    if (_dbUpdateInProgress) {
      return;
    }
    if (mounted) {
      setState(() {
        _dbUpdateInProgress = true;
      });
    }
    final changeResults = <UploadResult>[];
    for (final itemToDelete in _itemsToDelete) {
      changeResults.add(await deleteFromFirestore(itemToDelete));
      if (changeResults.last.type == UploadResultType.permissionDenied) {
        break;
      }
    }
    for (final itemToEdit in _itemsToEdit) {
      changeResults.add(await uploadToFirestore(itemToEdit));
      if (changeResults.last.type == UploadResultType.permissionDenied) {
        break;
      }
    }
    _displayUpdateResults(changeResults);
    _getFirestoreContents();
  }

  /// Displays [SnackBar] messages for each [UploadResultType] in [results].
  ///
  /// This method lives outside the deletion and modification methods because
  /// [BuildContext]s cannot be used in `async` methods.
  void _displayUpdateResults(List<UploadResult> results) {
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
          .map((result) => result.dbItem.id)
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
          .map((result) => result.dbItem.id)
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
          .map((result) => result.dbItem.id)
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
      final deletedIDs = successfulDeletes
        .map((delete) => delete.dbItem.id)
        .toList();
      _itemsToDelete.removeWhere((item) => deletedIDs.contains(item.id));
    }
    final successfulUpdates = results
        .where((result) => result.type == UploadResultType.successfulUpdate);
    if (successfulUpdates.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully updated ${successfulUpdates.length} '
            'item${successfulUpdates.length != 1 ? 's' : ''}!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ));
      final updatedIDs = successfulUpdates
        .map((update) => update.dbItem.id)
        .toList();
      _itemsToEdit.removeWhere((item) => updatedIDs.contains(item.id));
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
            if (_retrievedItems != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 10),
                child: Row(
                  children: [
                    Text('There are ${_retrievedItems!.length} items in the database.'),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _markOldEventsToDelete,
                      child: _dbUpdateInProgress
                          ? const Text('Upload in progress...')
                          : const Text('Delete all old events'),
                    ),
                    ElevatedButton(
                      onPressed: _applyChanges,
                      child: _dbUpdateInProgress
                          ? const Text("Upload in progress...")
                          : const Text("Apply changes"),
                    ),
                  ],
                ),
              ),
            if (_retrievedItems == null)
              const Center(child: Text('Loading...'))
            else
              TableScroller(
                child: DataTable(
                  columns: DatabaseItem.fieldTitles
                    .map((title) => DataColumn(
                      label: Text(title),
                    ))
                    .toList(),
                  rows: _retrievedItems!
                    .map((originalRowItem) {
                      final rowItem = _latestVersion(originalRowItem);
                      return DataRow(
                        cells: rowItem
                          .fieldContents
                          .map((dynamic cellData) => DataCell(
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 300,
                                maxHeight: 40,
                              ),
                              child: Text(
                                switch (cellData) {
                                  null => "",
                                  DateTime dt => DatabaseItem.formatDate(dt),
                                  dynamic otherType => otherType.toString(),
                                },
                                style: TextStyle(
                                  color: _markedForDeletion(rowItem)
                                    ? Theme.of(context).colorScheme.error
                                    : null,
                                  fontWeight: _markedForEdit(rowItem)
                                          || _markedForDeletion(rowItem)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                ),
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            onTap: () async {
                              await showDialog<DatabaseItem?>(
                                context: context,
                                builder: (context) => DatabaseEditDialog(
                                  dbItem: rowItem,
                                  isDeleted: _markedForDeletion(rowItem),
                                ),
                              ).then((editedItem) {
                                setState(() {
                                  _afterEditing(originalRowItem, editedItem);
                                });
                              });
                            },
                          ))
                          .toList(),
                      );
                    })
                    .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
