import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hendrix_today_uploader/firebase/constants.dart';
import 'package:hendrix_today_uploader/firebase/database_item.dart';

Future<List<DatabaseItem>> getFirestoreContents() async {
  final db = FirebaseFirestore.instance;
  final items = <DatabaseItem>[];
  final querySnapshot = await db.collection(collectionName).get();
  for (final docSnapshot in querySnapshot.docs) {
    final translatedItem = _translateDocSnapshot(docSnapshot.data());
    if (translatedItem case DatabaseItem dbItem) {
      items.add(dbItem);
    }
  }
  // sort by ID
  items.sort((a, b) => a.id.compareTo(b.id));
  print("download.dart got ${items.length} items from Firestore.");
  return items;
}

DatabaseItem? _translateDocSnapshot(Map<String, dynamic> snapshot) {
  DateTime? formatDateTime(dynamic dyn) => switch (dyn) {
    Timestamp ts => ts.toDate(),
    _ => null,
  };

  final String? idString = snapshot["id"]?.toString();
  if (idString == null) {
    return null;
  }
  final int? id = int.tryParse(idString);
  if (id == null) {
    return null;
  }
  final String? title = snapshot["title"]?.toString();
  if (title == null) {
    return null;
  }
  final String? desc = snapshot["desc"]?.toString();
  if (desc == null) {
    return null;
  }
  final DatabaseItemType? type = DatabaseItemType.fromString(
    snapshot["type"]?.toString(),
  );
  if (type == null) {
    return null;
  }
  final String? contactName = snapshot["contactName"]?.toString();
  if (contactName == null) {
    return null;
  }
  final String? contactEmail = snapshot["contactEmail"]?.toString();
  if (contactEmail == null) {
    return null;
  }
  final DateTime? beginPosting = formatDateTime(snapshot["beginPosting"]);
  if (beginPosting == null) {
    return null;
  }
  final DateTime? endPosting = formatDateTime(snapshot["endPosting"]);
  if (endPosting == null) {
    return null;
  }
  final DateTime? date = formatDateTime(snapshot["date"]);
  if (date == null) {
    return null;
  }
  final String? time = snapshot["time"]?.toString();
  final String? location = snapshot["location"]?.toString();
  final DateTime? applyDeadline = formatDateTime(snapshot["applyDeadline"]);
  return DatabaseItem(
    id: id,
    title: title,
    desc: desc,
    type: type,
    contactName: contactName,
    contactEmail: contactEmail,
    beginPosting: beginPosting,
    endPosting: endPosting,
    date: date,
    time: time,
    location: location,
    applyDeadline: applyDeadline,
  );
}
