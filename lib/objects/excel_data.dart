import 'package:excel/excel.dart';

import 'package:hendrix_today_uploader/firebase/constants.dart';

typedef ExcelRow = List<String?>;

extension NullSafeGet on ExcelRow {
  String? get(int index) => index >= 0 && index < length ? this[index] : null;
}

extension Format on ExcelRow {
  ExcelRow get format =>
      orderedFields.map((field) => get(field.index)).toList();
}

class ExcelData {
  ExcelData(Excel xl) {
    final sheet = xl.sheets[xl.getDefaultSheet()]!;
    rows = sheet.rows
        .map((row) => row.map((cell) => cell?.value?.toString()).toList())
        .toList();
    // sort by ID, with null/blank values first
    rows.sort((a, b) => (int.tryParse(a.get(idField.index) ?? '') ?? -1)
        .compareTo(int.tryParse(b.get(idField.index) ?? '') ?? -1));
  }
  late final List<ExcelRow> rows;
  int get rowCount => rows.length;
  int get colCount => rows.firstOrNull?.length ?? 0;

  static String columnLetter(int col) {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    // Algorithm source: https://learn.microsoft.com/en-us/office/troubleshoot/excel/convert-excel-column-numbers
    String result = '';
    col += 1;
    while (col > 0) {
      final a = (col - 1) ~/ 26;
      final b = (col - 1) % 26;
      result = alphabet[b] + result;
      col = a;
    }
    return result;
  }
}
