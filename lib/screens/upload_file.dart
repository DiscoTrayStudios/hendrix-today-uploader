import 'package:flutter/material.dart';

import 'package:excel/excel.dart';

class ExcelViewScreen extends StatelessWidget {
  const ExcelViewScreen({super.key, required this.excel});
  final Excel excel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload File"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("The default sheet is named "
            "${excel.sheets[excel.getDefaultSheet()]?.sheetName}"),
      ),
    );
  }
}
