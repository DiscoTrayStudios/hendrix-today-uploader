import 'package:flutter/material.dart';
import 'package:hendrix_today_uploader/firebase/database_item.dart';

class DatabaseEditDialog extends StatelessWidget {
  const DatabaseEditDialog({super.key, required this.dbItem});
  final DatabaseItem dbItem;

  @override
  Widget build(BuildContext context) {
    final titleEditingController = TextEditingController(
      text: dbItem.title,
    );
    final descriptionEditingController = TextEditingController(
      text: dbItem.desc,
    );
    final timeEditingController = TextEditingController(
      text: dbItem.time,
    );
    final locationEditingController = TextEditingController(
      text: dbItem.location,
    );
    
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, dbItem);
            },
            icon: const Icon(Icons.close),
            tooltip: "Close the editing window",
          ),
          Text("Edit Event ${dbItem.id}"),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                // TODO this button should be red
                onPressed: () {
                  Navigator.pop(context, null);
                }, 
                child: const Text("Delete"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, DatabaseItem(
                    id: dbItem.id,
                    title: titleEditingController.text,
                    desc: descriptionEditingController.text,
                    type: dbItem.type,
                    contactName: dbItem.contactName,
                    contactEmail: dbItem.contactEmail,
                    beginPosting: dbItem.beginPosting,
                    endPosting: dbItem.endPosting,
                    date: dbItem.date,
                    time: timeEditingController.text,
                    location: locationEditingController.text,
                    applyDeadline: dbItem.applyDeadline,
                  ));
                },
                child: const Text("Update"),
              ),
            ],
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
                    // Text(fieldContents?.toString() ?? ""),
                    switch (fieldContents) {
                      String stringContents => TextField(
                        controller: TextEditingController(
                          text: stringContents,
                        ),
                      ),
                      _ => Text(fieldContents?.toString() ?? "<empty field>"),
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}