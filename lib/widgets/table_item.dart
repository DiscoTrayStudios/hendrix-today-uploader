import 'package:flutter/material.dart';

class TableItem extends StatelessWidget {
  const TableItem({super.key, required this.cellValue, this.maxLength = -1});
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
