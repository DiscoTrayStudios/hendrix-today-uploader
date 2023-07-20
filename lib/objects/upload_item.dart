import 'package:hendrix_today_uploader/objects/excel_data.dart';

class ExcelFieldMap {
  const ExcelFieldMap({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.contactName,
    required this.contactEmail,
    required this.beginPosting,
    required this.endPosting,
    this.date,
    this.time,
    this.location,
    this.applyDeadline,
  });
  final int id;
  final int title;
  final int description;
  final int type;
  final int contactName;
  final int contactEmail;
  final int beginPosting;
  final int endPosting;
  final int? date;
  final int? time;
  final int? location;
  final int? applyDeadline;

  void printMap() {
    print([
      id,
      title,
      description,
      type,
      contactName,
      contactEmail,
      beginPosting,
      endPosting,
      date,
      time,
      location,
      applyDeadline
    ].join(', '));
  }
}

class UploadItem {
  const UploadItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.contactName,
    required this.contactEmail,
    required this.beginPosting,
    required this.endPosting,
    this.date,
    this.time,
    this.location,
    this.applyDeadline,
  });
  final String id;
  final String title;
  final String description;
  final String type;
  final String contactName;
  final String contactEmail;
  final String beginPosting;
  final String endPosting;
  final String? date;
  final String? time;
  final String? location;
  final String? applyDeadline;

  static UploadItem? fromExcelData(
      ExcelData excel, int row, ExcelFieldMap map) {
    final rowData = excel.data[row];
    if (rowData[map.id] == null) return null;
    if (rowData[map.title] == null) return null;
    if (rowData[map.description] == null) return null;
    if (rowData[map.type] == null) return null;
    if (rowData[map.contactName] == null) return null;
    if (rowData[map.contactEmail] == null) return null;
    if (rowData[map.beginPosting] == null) return null;
    if (rowData[map.endPosting] == null) return null;
    return UploadItem(
      id: rowData[map.id]!,
      title: rowData[map.title]!,
      description: rowData[map.description]!,
      type: rowData[map.type]!,
      contactName: rowData[map.contactName]!,
      contactEmail: rowData[map.contactEmail]!,
      beginPosting: rowData[map.beginPosting]!,
      endPosting: rowData[map.endPosting]!,
      date: map.date != null ? rowData[map.date!] : null,
      time: map.time != null ? rowData[map.time!] : null,
      location: map.location != null ? rowData[map.location!] : null,
      applyDeadline:
          map.applyDeadline != null ? rowData[map.applyDeadline!] : null,
    );
  }
}
