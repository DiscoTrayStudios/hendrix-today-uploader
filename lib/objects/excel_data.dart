import 'package:excel/excel.dart';

import 'package:hendrix_today_uploader/firebase/constants.dart';
import 'package:hendrix_today_uploader/firebase/database_item.dart';
import 'package:hendrix_today_uploader/firebase/download.dart'
    show formatDateTime;

typedef ExcelRow = List<String?>;

extension NullSafeGet on ExcelRow {
  String? get(int index) => index >= 0 && index < length ? this[index] : null;
}

extension Format on ExcelRow {
  ExcelRow get format =>
      orderedFields.map((field) => get(field.column)).toList();
}

extension AsDatabaseItem on ExcelRow {
  DatabaseItem? asDatabaseItem() {
    // monadic bind for nullable types; allows for short-cirtuiting
    U? then<T, U>(T? first, U? Function(T) next) => switch (first) {
        null => null,
        T t => next(t),
    };
    return then(
      get(idField.column),
      (String idString) => then(
        int.tryParse(idString),
        (int id) => then(
          get(titleField.column),
          (String title) => then(
            get(descField.column),
            (String desc) => then(
              DatabaseItemType.fromString(get(typeField.column)),
              (DatabaseItemType type) => then(
                get(contactNameField.column),
                (String contactName) => then(
                  get(contactEmailField.column),
                  (String contactEmail) => then(
                    formatDateTime(get(beginPostingField.column)),
                    (DateTime beginPosting) => then(
                      formatDateTime(get(endPostingField.column)),
                      (DateTime endPosting) => then(
                        formatDateTime(get(dateField.column)),
                        (DateTime date) => DatabaseItem(
                            id: id,
                            title: title,
                            desc: desc,
                            type: type,
                            contactName: contactName,
                            contactEmail: contactEmail,
                            beginPosting: beginPosting,
                            endPosting: endPosting,
                            date: date,
                            time: get(timeField.column),
                            location: get(locationField.column),
                            applyDeadline: formatDateTime(
                              get(applyDeadlineField.column),
                            ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExcelData {
  ExcelData(Excel xl) {
    final sheet = xl.sheets[xl.getDefaultSheet()]!;
    rows = sheet.rows
        .map((row) => row.map((cell) => cell?.value?.toString()).toList())
        .toList();
    // sort by ID, with null/blank values first
    rows.sort((a, b) => (int.tryParse(a.get(idField.column) ?? '') ?? -1)
        .compareTo(int.tryParse(b.get(idField.column) ?? '') ?? -1));
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
