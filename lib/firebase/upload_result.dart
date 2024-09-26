import 'package:hendrix_today_uploader/firebase/database_item.dart';

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
  const UploadResult(this.type, this.dbItem);
  final UploadResultType type;
  final DatabaseItem dbItem;

  factory UploadResult.successfulInsert(DatabaseItem dbItem) =>
      UploadResult(UploadResultType.successfulInsert, dbItem);
  factory UploadResult.successfulUpdate(DatabaseItem dbItem) =>
      UploadResult(UploadResultType.successfulUpdate, dbItem);
  factory UploadResult.successfulDelete(DatabaseItem dbItem) =>
      UploadResult(UploadResultType.successfulDelete, dbItem);
  factory UploadResult.permissionDenied(DatabaseItem dbItem) =>
      UploadResult(UploadResultType.permissionDenied, dbItem);
  factory UploadResult.invalidFields(DatabaseItem dbItem) =>
      UploadResult(UploadResultType.invalidFields, dbItem);
  factory UploadResult.idNotPresent(DatabaseItem dbItem) =>
      UploadResult(UploadResultType.idNotPresent, dbItem);
  factory UploadResult.unknownError(DatabaseItem dbItem) =>
      UploadResult(UploadResultType.unknownError, dbItem);
}
