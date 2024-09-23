import 'package:flutter/material.dart';
import 'package:hendrix_today_uploader/firebase/database_item.dart';

// TODO this widget should probably be stateful, since it needs to modify and return an updated dbItem
class DatabaseEditDialog extends StatelessWidget {
  const DatabaseEditDialog({super.key, required this.dbItem});
  final DatabaseItem dbItem;

  @override
  Widget build(BuildContext context) {
    final id = dbItem.id;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              // TODO close the AlertDialog with no change
            },
            icon: const Icon(Icons.close),
            tooltip: "Close the editing window",
          ),
          Text("Edit Event $id"),
          TextButton(
            // TODO this button should be red
            onPressed: () {
              // TODO return from the showDialog with a message to delete this item
            }, 
            child: const Text("Delete"),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text("Field"),
            ),
            DataColumn(
              label: Text("Contents"),
            ),
          ],
          rows: List.generate(
            DatabaseItem.fieldCount,
            (fieldIndex) {
              final fieldTitle = DatabaseItem.fieldTitles[fieldIndex];
              final fieldContents = dbItem.fieldContents[fieldIndex];
              return DataRow(
                cells: [
                  DataCell(
                    Text(fieldTitle),
                  ),
                  DataCell(
                    Text(fieldContents),
                  ),
                ],
              );
            },
          ),
          // rows: orderedFields
          //   .indexed
          //   .map((tup) {
          //     final i = tup.$1;
          //     final field = tup.$2;
          //     return DataRow(
          //       cells: [
          //         DataCell(
          //           Text(field.name),
          //         ),
          //         DataCell(
          //           Container(
          //             constraints: const BoxConstraints(
          //               maxWidth: 500,
          //             ),
          //             child: TextField(
          //               controller: TextEditingController(
          //                 text: dbRow[i],
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     );
          //   })
          //   .toList(),
        ),
      ),
    );
  }
}