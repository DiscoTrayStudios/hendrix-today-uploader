import 'package:flutter/material.dart';

import 'package:hendrix_today_uploader/firebase/constants.dart';
import 'package:hendrix_today_uploader/objects/excel_data.dart';
import 'package:hendrix_today_uploader/widgets/table_item.dart';
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
            children: orderedFields
                .map((field) => Center(
                      child: TableItem(
                        cellValue:
                            '${field.name} (${ExcelData.columnLetter(field.index)})',
                      ),
                    ))
                .toList(),
          ),
          ...excel.rows.map((row) => TableRow(
              children: row.format
                  .map((cellValue) =>
                      TableItem(cellValue: cellValue, maxLength: 40))
                  .toList())),
        ],
      ),
    );
  }
}
