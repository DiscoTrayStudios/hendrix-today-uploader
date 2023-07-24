import 'package:flutter/material.dart' show debugPrint;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hendrix_today_uploader/objects/excel_data.dart';

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
  final int id;
  final String title;
  final String description;
  final String type;
  final String contactName;
  final String contactEmail;
  final DateTime beginPosting;
  final DateTime endPosting;
  final DateTime? date;
  final String? time;
  final String? location;
  final DateTime? applyDeadline;

  static bool isValidExcelRow(ExcelRow row) {
    if (row.get(idColumn) == null) return false;
    if (int.tryParse(row.get(idColumn)!) == null) return false;
    if (row.get(titleColumn) == null) return false;
    if (row.get(descriptionColumn) == null) return false;
    if (row.get(typeColumn) == null) return false;
    if (row.get(contactNameColumn) == null) return false;
    if (row.get(contactEmailColumn) == null) return false;
    if (row.get(beginPostingColumn) == null) return false;
    if (DateTime.tryParse(row.get(beginPostingColumn)!) == null) return false;
    if (row.get(endPostingColumn) == null) return false;
    if (DateTime.tryParse(row.get(endPostingColumn)!) == null) return false;
    return true;
  }

  static UploadItem? fromExcelRow(ExcelRow row) {
    return isValidExcelRow(row)
        ? UploadItem(
            id: int.parse(row.get(idColumn)!),
            title: row.get(titleColumn)!,
            description: row.get(descriptionColumn)!,
            type: row.get(typeColumn)!,
            contactName: row.get(contactNameColumn)!,
            contactEmail: row.get(contactEmailColumn)!,
            beginPosting: DateTime.parse(row.get(beginPostingColumn)!),
            endPosting: DateTime.parse(row.get(endPostingColumn)!),
            date: DateTime.tryParse(row.get(dateColumn) ?? ''),
            time: row.get(timeColumn),
            location: row.get(locationColumn),
            applyDeadline:
                DateTime.tryParse(row.get(applyDeadlineColumn) ?? ''),
          )
        : null;
  }

  void uploadToFirestore() async {
    final db = FirebaseFirestore.instance;
    const collName = 'uploaderTest';
    final data = <String, dynamic>{
      'id': id,
      'title': title,
      'desc': description,
      'eventType': type,
      'contactName': contactName,
      'contactEmail': contactEmail,
      'beginPosting': beginPosting,
      'endPosting': endPosting,
      'date': date,
      'time': time,
      'location': location,
      'applyDeadline': applyDeadline,
    };
    final match =
        (await db.collection(collName).where('id', isEqualTo: id).get())
            .docs
            .firstOrNull;
    if (match == null) {
      db
          .collection(collName)
          .add(data)
          .then((docRef) => debugPrint('Document added with ID: ${docRef.id}'));
    } else {
      match.reference
          .set(data)
          .then((_) => debugPrint('Document updated with ID: ${match.id}'));
    }
  }
}
