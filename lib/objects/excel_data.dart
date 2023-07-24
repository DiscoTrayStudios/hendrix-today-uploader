import 'package:excel/excel.dart';

// The following constants should be defined in accordance with the Excel sheet
// output by the submission form: column A = 0, B = 1, etc.
const idColumn = 0;
const titleColumn = 8;
const descriptionColumn = 15;
const typeColumn = 11;
const contactNameColumn = 6;
const contactEmailColumn = 7;
const beginPostingColumn = 9;
const endPostingColumn = 10;
const dateColumn = 12;
const timeColumn = 14;
const locationColumn = 17;
const applyDeadlineColumn = 13;

// Keep the following two lists in the same order
const orderedColumnIndicies = [
  idColumn,
  titleColumn,
  descriptionColumn,
  typeColumn,
  contactNameColumn,
  contactEmailColumn,
  beginPostingColumn,
  endPostingColumn,
  dateColumn,
  timeColumn,
  locationColumn,
  applyDeadlineColumn,
];
const orderedColumnNames = [
  'ID',
  'Title',
  'Description',
  'Type',
  'Contact name',
  'Contact email',
  'First day to post',
  'Last day to post',
  'Date (optional)',
  'Time (optional)',
  'Location (optional)',
  'Application deadline (optional)',
];

typedef ExcelRow = List<String?>;

extension NullSafeGet on ExcelRow {
  String? get(int index) => index >= 0 && index < length ? this[index] : null;
}

extension Format on ExcelRow {
  ExcelRow get format => orderedColumnIndicies.map((i) => get(i)).toList();
}

class ExcelData {
  ExcelData(Excel xl) {
    final sheet = xl.sheets[xl.getDefaultSheet()]!;
    rows = sheet.rows
        .map((row) => row.map((cell) => cell?.value?.toString()).toList())
        .toList();
    // sort by ID, with null/blank values first
    rows.sort((a, b) => (int.tryParse(a.get(idColumn) ?? '') ?? -1)
        .compareTo(int.tryParse(b.get(idColumn) ?? '') ?? -1));
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
