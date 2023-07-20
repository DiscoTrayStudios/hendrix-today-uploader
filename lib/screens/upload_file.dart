import 'package:flutter/material.dart';

import 'package:hendrix_today_uploader/objects/excel_data.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExcelTable(excel: excel),
      ),
    );
  }
}
