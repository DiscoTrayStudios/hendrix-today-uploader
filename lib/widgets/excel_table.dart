import 'package:flutter/material.dart';

import 'package:hendrix_today_uploader/objects/excel_data.dart';
import 'package:hendrix_today_uploader/widgets/table_scroller.dart';

class ExcelTable extends StatelessWidget {
  const ExcelTable({super.key, required this.excel});
  final ExcelData excel;

  @override
  Widget build(BuildContext context) {
    return TableScroller(
      child: Table(
        border: TableBorder.all(color: Theme.of(context).colorScheme.primary),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          TableRow(
            children: List.generate(
              orderedColumnIndicies.length,
              (i) => Center(
                child: _TableItem(
                  cellValue: '${orderedColumnNames[i]} '
                      '(${ExcelData.columnLetter(orderedColumnIndicies[i])})',
                ),
              ),
            ),
          ),
          ...excel.rows.map((row) => TableRow(
              children: row.format
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
