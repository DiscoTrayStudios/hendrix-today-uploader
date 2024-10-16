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
  late final TextEditingController contactNameEditingController;
  late final TextEditingController contactEmailEditingController;
  late final TextEditingController timeEditingController;
  late final TextEditingController locationEditingController;
  late DatabaseItemType editingType;
  late DateTime editingBeginPosting;
  late DateTime editingEndPosting;
  late DateTime editingDate;
  late DateTime? editingApplyDeadline;

  @override
  void initState() {
    super.initState();
    titleEditingController = TextEditingController(
      text: widget.dbItem.title,
    );
    descriptionEditingController = TextEditingController(
      text: widget.dbItem.desc,
    );
    contactNameEditingController = TextEditingController(
      text: widget.dbItem.contactName,
    );
    contactEmailEditingController = TextEditingController(
      text: widget.dbItem.contactEmail,
    );
    timeEditingController = TextEditingController(
      text: widget.dbItem.time,
    );
    locationEditingController = TextEditingController(
      text: widget.dbItem.location,
    );
    editingType = widget.dbItem.type;
    editingBeginPosting = widget.dbItem.beginPosting;
    editingEndPosting = widget.dbItem.endPosting;
    editingDate = widget.dbItem.date;
    editingApplyDeadline = widget.dbItem.applyDeadline;
  }

  @override
  void dispose() {
    titleEditingController.dispose();
    descriptionEditingController.dispose();
    contactNameEditingController.dispose();
    contactEmailEditingController.dispose();
    timeEditingController.dispose();
    locationEditingController.dispose();
    super.dispose();
  }

  DatabaseItem get _newItem => DatabaseItem(
      id: widget.dbItem.id,
      title: titleEditingController.text,
      desc: descriptionEditingController.text,
      type: editingType,
      contactName: contactNameEditingController.text,
      contactEmail: contactEmailEditingController.text,
      beginPosting: editingBeginPosting,
      endPosting: editingEndPosting,
      date: editingDate,
      time: timeEditingController.text,
      location: locationEditingController.text,
      applyDeadline: editingApplyDeadline,
    );

  Future<DateTime?> _updateDate(BuildContext context, DateTime? original) async => await showDatePicker(
      context: context,
      firstDate: DateTime(0, 1, 1),
      lastDate: DateTime(9999, 12, 31),
      initialDate: original,
    );

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
                  Navigator.pop(context, _newItem);
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
          rows: <(String, Widget)>[
            // all fields written individually, maybe refactor someday?
              ("Title", TextField(
                controller: titleEditingController,
                maxLines: null,
              )),
              ("Description", TextField(
                controller: descriptionEditingController,
                maxLines: null,
              )),
              ("Type", DropdownButton<DatabaseItemType>(
                value: editingType,
                items: DatabaseItemType.values
                    .map((e) => DropdownMenuItem<DatabaseItemType>(
                      value: e,
                      child: Text(e.toString())
                    )).toList(),
                onChanged: (newType) {
                  setState(() {
                    editingType = newType ?? editingType;
                  });
                },
              )),
              ("Contact name", TextField(
                controller: contactNameEditingController,
                maxLines: null,
              )),
              ("Contact email", TextField(
                controller: contactEmailEditingController,
                maxLines: null,
              )),
              ("First day to post", Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: () async {
                      final newDate = await _updateDate(
                        context,
                        editingBeginPosting,
                      );
                      setState(() {
                        editingBeginPosting = newDate ?? editingBeginPosting;
                      });
                    },
                  ),
                  Text(editingBeginPosting.toString()),
                ],
              )),
              ("Last day to post", Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: () async {
                      final newDate = await _updateDate(
                        context,
                        editingEndPosting,
                      );
                      setState(() {
                        editingEndPosting = newDate ?? editingEndPosting;
                      });
                    }
                  ),
                  Text(editingEndPosting.toString()),
                ],
              )),
              ("Date", Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: () async {
                      final newDate = await _updateDate(
                        context,
                        editingDate,
                      );
                      setState(() {
                        editingDate = newDate ?? editingDate;
                      });
                    }
                  ),
                  Text(editingDate.toString()),
                ],
              )),
              // TODO add trash can buttons to clear optional fields
              ("Time (optional)", TextField(
                controller: timeEditingController,
                maxLines: null,
              )),
              ("Location (optional)", TextField(
                controller: locationEditingController,
                maxLines: null,
              )),
              ("Application deadline (optional)", Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: () async {
                      final newDate = await _updateDate(
                        context,
                        editingApplyDeadline,
                      );
                      setState(() {
                        editingApplyDeadline = newDate ?? editingApplyDeadline;
                      });
                    }
                  ),
                  Text(editingApplyDeadline?.toString() ?? "<empty field>"),
                ],
              )),
          ].map((tup) {
            final label = tup.$1;
            final contents = tup.$2;
            return DataRow(
              cells: [
                DataCell(Text(label)),
                DataCell(contents),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}