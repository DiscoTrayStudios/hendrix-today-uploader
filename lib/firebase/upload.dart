import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hendrix_today_uploader/firebase/constants.dart';
import 'package:hendrix_today_uploader/firebase/database_item.dart';
import 'package:hendrix_today_uploader/firebase/upload_result.dart';

/// Uploads a [DatabaseItem] to Firestore, or edits the existing one if the ID
/// of the given item is already present in Firestore.
Future<UploadResult> uploadToFirestore(DatabaseItem dbItem) async {
  final data = dbItem.generateDocumentSnapshot();
  final db = FirebaseFirestore.instance;
  try {
    final match = (await db
            .collection(collectionName)
            .where("id", isEqualTo: data["id"])
            .get())
        .docs
        .firstOrNull;
    if (match == null) {
      await db.collection(collectionName).add(data);
      return UploadResult.successfulInsert(dbItem);
    } else {
      await match.reference.set(data);
      return UploadResult.successfulUpdate(dbItem);
    }
  } on FirebaseException catch (firebaseException) {
    if (firebaseException.code == "permission-denied") {
      return UploadResult.permissionDenied(dbItem);
    }
    return UploadResult.unknownError(dbItem);
  } catch (unknownError) {
    return UploadResult.unknownError(dbItem);
  }
}

/// Delete a [DatabaseItem] from Firestore. Does nothing to the database if the
/// ID is not present in Firestore.
Future<UploadResult> deleteFromFirestore(DatabaseItem dbItem) async {
  final id = dbItem.id;
  final db = FirebaseFirestore.instance;
  try {
    final matches =
        (await db.collection(collectionName).where("id", isEqualTo: id).get())
            .docs;
    if (matches.isEmpty) return UploadResult.idNotPresent(dbItem);
    for (final match in matches) {
      await match.reference.delete();
    }
  } on FirebaseException catch (firebaseException) {
    if (firebaseException.code == "permission-denied") {
      return UploadResult.permissionDenied(dbItem);
    }
    return UploadResult.unknownError(dbItem);
  } catch (unknownError) {
    return UploadResult.unknownError(dbItem);
  }
  return UploadResult.successfulDelete(dbItem);
}
