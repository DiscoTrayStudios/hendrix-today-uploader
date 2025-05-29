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
  factory UploadResult.invalidFields() => UploadResult(
      UploadResultType.invalidFields,
      DatabaseItem(
        id: 0,
        title: "",
        desc: "",
        type: DatabaseItemType.event,
        contactName: "",
        contactEmail: "",
        beginPosting: DateTime.fromMillisecondsSinceEpoch(0),
        endPosting: DateTime.fromMillisecondsSinceEpoch(0),
        date: DateTime.fromMillisecondsSinceEpoch(0),
        time: null,
        location: null,
        applyDeadline: null,
        hip: null,
      ));
  factory UploadResult.idNotPresent(DatabaseItem dbItem) =>
      UploadResult(UploadResultType.idNotPresent, dbItem);
  factory UploadResult.unknownError(DatabaseItem dbItem) =>
      UploadResult(UploadResultType.unknownError, dbItem);
}
