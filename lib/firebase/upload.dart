import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hendrix_today_uploader/firebase/constants.dart';
import 'package:hendrix_today_uploader/objects/excel_data.dart';

enum UploadResultType {
  successfulInsert,
  successfulUpdate,
  successfulDelete,
  permissionDenied,
  invalidFields,
  idNotPresent,
  unknownError;
}

class UploadResult {
  const UploadResult(this.type, this.snapshot);
  final UploadResultType type;
  final ExcelRow snapshot;

  factory UploadResult.successfulInsert(ExcelRow row) =>
      UploadResult(UploadResultType.successfulInsert, List.unmodifiable(row));
  factory UploadResult.successfulUpdate(ExcelRow row) =>
      UploadResult(UploadResultType.successfulUpdate, List.unmodifiable(row));
  factory UploadResult.successfulDelete(ExcelRow row) =>
      UploadResult(UploadResultType.successfulDelete, List.unmodifiable(row));
  factory UploadResult.permissionDenied(ExcelRow row) =>
      UploadResult(UploadResultType.permissionDenied, List.unmodifiable(row));
  factory UploadResult.invalidFields(ExcelRow row) =>
      UploadResult(UploadResultType.invalidFields, List.unmodifiable(row));
  factory UploadResult.idNotPresent(ExcelRow row) =>
      UploadResult(UploadResultType.idNotPresent, List.unmodifiable(row));
  factory UploadResult.unknownError(ExcelRow row) =>
      UploadResult(UploadResultType.unknownError, List.unmodifiable(row));
}

Future<UploadResult> uploadToFirestore(ExcelRow row) async {
  if (!_isValidExcelRow(row)) return UploadResult.invalidFields(row);
  final data = _generateDocumentSnapshot(row);
  final db = FirebaseFirestore.instance;
  try {
    final match = (await db
            .collection(collectionName)
            .where('id', isEqualTo: data['id'])
            .get())
        .docs
        .firstOrNull;
    if (match == null) {
      await db.collection(collectionName).add(data);
      return UploadResult.successfulInsert(row);
    } else {
      await match.reference.set(data);
      return UploadResult.successfulUpdate(row);
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
  if (row.get(idField.index) == null) return false;
  if (int.tryParse(row.get(idField.index)!) == null) return false;
  if (row.get(titleField.index) == null) return false;
  if (row.get(descField.index) == null) return false;
  if (row.get(typeField.index) == null) return false;
  if (row.get(contactNameField.index) == null) return false;
  if (row.get(contactEmailField.index) == null) return false;
  if (row.get(beginPostingField.index) == null) return false;
  if (row.get(dateField.index) == null) return false;
  if (DateTime.tryParse(row.get(beginPostingField.index)!) == null) {
    return false;
  }
  if (row.get(endPostingField.index) == null) return false;
  if (DateTime.tryParse(row.get(endPostingField.index)!) == null) return false;
  return true;
}

Map<String, dynamic> _generateDocumentSnapshot(ExcelRow row) => {
      'id': int.parse(row.get(idField.index)!),
      'title': row.get(titleField.index)!,
      'desc': row.get(descField.index)!,
      'type': row.get(typeField.index)!,
      'contactName': row.get(contactNameField.index)!,
      'contactEmail': row.get(contactEmailField.index)!,
      'beginPosting': DateTime.parse(row.get(beginPostingField.index)!),
      'endPosting': DateTime.parse(row.get(endPostingField.index)!),
      'date': DateTime.parse(row.get(dateField.index)!),
      'time': row.get(timeField.index),
      'location': row.get(locationField.index),
      'applyDeadline':
          DateTime.tryParse(row.get(applyDeadlineField.index) ?? ''),
    };

Future<UploadResult> deleteFromFirestore(ExcelRow row) async {
  final id = int.tryParse(row.get(idField.index) ?? '');
  if (id == null) return UploadResult.invalidFields(row);
  final db = FirebaseFirestore.instance;
  try {
    final matches =
        (await db.collection(collectionName).where('id', isEqualTo: id).get())
            .docs;
    if (matches.isEmpty) return UploadResult.idNotPresent(row);
    for (final match in matches) {
      await match.reference.delete();
    }
  } on FirebaseException catch (firebaseException) {
    if (firebaseException.code == 'permission-denied') {
      return UploadResult.permissionDenied(row);
    }
    return UploadResult.unknownError(row);
  } catch (unknownError) {
    return UploadResult.unknownError(row);
  }
  return UploadResult.successfulDelete(row);
}
