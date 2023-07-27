import 'package:flutter/material.dart';

import 'package:hendrix_today_uploader/firebase/download.dart';
import 'package:hendrix_today_uploader/firebase/constants.dart';
import 'package:hendrix_today_uploader/widgets/table_item.dart';
import 'package:hendrix_today_uploader/widgets/table_scroller.dart';

class DatabaseViewScreen extends StatefulWidget {
  const DatabaseViewScreen({super.key});

  @override
  State<DatabaseViewScreen> createState() => _DatabaseViewScreenState();
}

class _DatabaseViewScreenState extends State<DatabaseViewScreen> {
  List<FirestoreRow>? _items;

  @override
  void initState() {
    super.initState();
    _getFirestoreContents();
  }

  void _getFirestoreContents() async {
    final items = await getFirestoreContents();
    setState(() {
      _items = items;
    });
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
                padding: const EdgeInsets.all(8),
                child:
                    Text('There are ${_items!.length} items in the database.'),
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
