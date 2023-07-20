import 'package:flutter/material.dart';

import 'package:hendrix_today_uploader/objects/excel_data.dart';
import 'package:hendrix_today_uploader/objects/upload_item.dart';
import 'package:hendrix_today_uploader/widgets/column_selector.dart';
import 'package:hendrix_today_uploader/widgets/excel_table.dart';

class UploadFileScreen extends StatelessWidget {
  const UploadFileScreen({super.key, required this.excel});
  final ExcelData excel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload File'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                final ExcelFieldMap? map = await showDialog(
                    context: context,
                    builder: (context) =>
                        ColumnSelector(columnCount: excel.colCount));
                map?.printMap();
                // TODO: create an UploadItem using the map
              },
              child: const Text('Define your columns...'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExcelTable(excel: excel),
          ),
        ],
      ),
    );
  }
}
