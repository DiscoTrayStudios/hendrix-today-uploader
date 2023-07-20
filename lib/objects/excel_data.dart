import 'package:excel/excel.dart';

class ExcelData {
  ExcelData(Excel xl) {
    final sheet = xl.sheets[xl.getDefaultSheet()]!;
    data = sheet.rows
        .map((row) => row.map((cell) => cell?.value?.toString()).toList())
        .toList();
  }
  late final List<List<String?>> data;
  int get rowCount => data.length;
  int get colCount => data.firstOrNull?.length ?? 0;

  static const String emptyCellValue = '';

  String get(int col, int row, [String defaultValue = emptyCellValue]) =>
      col < 0 || col >= colCount || row < 0 || row >= rowCount
          ? defaultValue
          : data[row][col] ?? emptyCellValue;
}
