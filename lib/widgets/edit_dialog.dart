import 'package:flutter/material.dart';
import 'package:hendrix_today_uploader/firebase/database_item.dart';

class DatabaseEditDialog extends StatefulWidget {
  const DatabaseEditDialog({
    super.key,
    required this.dbItem,
    required this.isDeleted,
  });
  final DatabaseItem dbItem;
  final bool isDeleted;

  @override
  State<DatabaseEditDialog> createState() => _DatabaseEditDialogState();
}

class _DatabaseEditDialogState extends State<DatabaseEditDialog> {

  late final TextEditingController titleEditingController;
  late final TextEditingController descriptionEditingController;
  late final TextEditingController timeEditingController;
  late final TextEditingController locationEditingController;

  @override
  void initState() {
    super.initState();
    titleEditingController = TextEditingController(
      text: widget.dbItem.title,
    );
    descriptionEditingController = TextEditingController(
      text: widget.dbItem.desc,
    );
    timeEditingController = TextEditingController(
      text: widget.dbItem.time,
    );
    locationEditingController = TextEditingController(
      text: widget.dbItem.location,
    );
  }

  @override
  void dispose() {
    titleEditingController.dispose();
    descriptionEditingController.dispose();
    timeEditingController.dispose();
    locationEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, widget.dbItem);
            },
            icon: const Icon(Icons.close),
            tooltip: "Close the editing window",
          ),
          Text("Edit Event ${widget.dbItem.id}"),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    widget.isDeleted ? widget.dbItem : null
                  );
                }, 
                child: Text(widget.isDeleted ? "Undelete" : "Delete"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, DatabaseItem(
                    id: widget.dbItem.id,
                    title: titleEditingController.text,
                    desc: descriptionEditingController.text,
                    type: widget.dbItem.type,
                    contactName: widget.dbItem.contactName,
                    contactEmail: widget.dbItem.contactEmail,
                    beginPosting: widget.dbItem.beginPosting,
                    endPosting: widget.dbItem.endPosting,
                    date: widget.dbItem.date,
                    time: timeEditingController.text,
                    location: locationEditingController.text,
                    applyDeadline: widget.dbItem.applyDeadline,
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
          dataRowMaxHeight: double.infinity,
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
              final fieldContents = widget.dbItem.fieldContents[fieldIndex];
              return DataRow(
                cells: [
                  DataCell(
                    Text(fieldTitle),
                  ),
                  DataCell(
                    // Text(fieldContents?.toString() ?? ""),
                    switch (fieldContents) {
                      String? _ => TextField(
                        controller: switch (fieldTitle) {
                          "Title" => titleEditingController,
                          "Description" => descriptionEditingController,
                          "Time (optional)" => timeEditingController,
                          "Location (optional)" => locationEditingController,
                          _ => null,
                        },
                        maxLines: null,
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