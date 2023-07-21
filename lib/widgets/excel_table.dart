import 'package:flutter/material.dart';

import 'package:hendrix_today_uploader/objects/excel_data.dart';
import 'package:hendrix_today_uploader/widgets/table_scroller.dart';

class ExcelTable extends StatelessWidget {
  const ExcelTable({super.key, required this.excel});
  final ExcelData excel;

  String _generateColumnLetter(int iCol) {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    // Algorithm source: https://learn.microsoft.com/en-us/office/troubleshoot/excel/convert-excel-column-numbers
    String result = '';
    iCol += 1;
    while (iCol > 0) {
      final a = (iCol - 1) ~/ 26;
      final b = (iCol - 1) % 26;
      result = alphabet[b] + result;
      iCol = a;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return TableScroller(
      child: Table(
        border: TableBorder.all(color: Theme.of(context).colorScheme.primary),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          TableRow(
            children: List.generate(
              excel.colCount,
              (i) => Center(
                  child: _TableItem(cellValue: _generateColumnLetter(i))),
            ),
          ),
          ...excel.rows.map((row) => TableRow(
              children: row
                  .map((cellValue) =>
                      _TableItem(cellValue: cellValue, maxLength: 40))
                  .toList())),
        ],
      ),
    );
  }
}

class _TableItem extends StatelessWidget {
  const _TableItem({required this.cellValue, this.maxLength = -1});
  final String? cellValue;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(cellValue == null
          ? ''
          : maxLength > 0 && cellValue!.length > maxLength
              ? '${cellValue!.substring(0, maxLength)}...'
              : cellValue!),
    );
  }
}
