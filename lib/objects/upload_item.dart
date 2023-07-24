import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hendrix_today_uploader/objects/excel_data.dart';

enum UploadResultType {
  success,
  permissionDenied,
  invalidFields,
  unknownError;
}

class UploadResult {
  const UploadResult(this.type, this.snapshot);
  final UploadResultType type;
  final ExcelRow snapshot;

  factory UploadResult.success(ExcelRow snapshot) =>
      UploadResult(UploadResultType.success, snapshot);
  factory UploadResult.permissionDenied(ExcelRow snapshot) =>
      UploadResult(UploadResultType.permissionDenied, snapshot);
  factory UploadResult.invalidFields(ExcelRow snapshot) =>
      UploadResult(UploadResultType.invalidFields, snapshot);
  factory UploadResult.unknownError(ExcelRow snapshot) =>
      UploadResult(UploadResultType.unknownError, snapshot);
}

Future<UploadResult> uploadToFirestore(ExcelRow row) async {
  if (!_isValidExcelRow(row)) return UploadResult.invalidFields(row);
  final data = _generateDocumentSnapshot(row);
  final db = FirebaseFirestore.instance;
  const collName = 'uploaderTest';
  try {
    final match =
        (await db.collection(collName).where('id', isEqualTo: data['id']).get())
            .docs
            .firstOrNull;
    if (match == null) {
      await db.collection(collName).add(data);
      return UploadResult.success(row);
    } else {
      await match.reference.set(data);
      return UploadResult.success(row);
    }
  } on FirebaseException catch (firebaseException) {
    if (firebaseException.code == 'permission-denied') {
      return UploadResult.permissionDenied(row);
    }
    return UploadResult.unknownError(row);
  } catch (unknownError) {
    return UploadResult.unknownError(row);
  }
}

bool _isValidExcelRow(ExcelRow row) {
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

Map<String, dynamic> _generateDocumentSnapshot(ExcelRow row) => {
      'id': int.parse(row.get(idColumn)!),
      'title': row.get(titleColumn)!,
      'description': row.get(descriptionColumn)!,
      'type': row.get(typeColumn)!,
      'contactName': row.get(contactNameColumn)!,
      'contactEmail': row.get(contactEmailColumn)!,
      'beginPosting': DateTime.parse(row.get(beginPostingColumn)!),
      'endPosting': DateTime.parse(row.get(endPostingColumn)!),
      'date': DateTime.tryParse(row.get(dateColumn) ?? ''),
      'time': row.get(timeColumn),
      'location': row.get(locationColumn),
      'applyDeadline': DateTime.tryParse(row.get(applyDeadlineColumn) ?? ''),
    };
