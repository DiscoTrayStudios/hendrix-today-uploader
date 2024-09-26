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
  // monadic bind for nullable types; allows for short-cirtuiting
  U? then<T, U>(T? first, U? Function(T) next) => switch (first) {
      null => null,
      T t => next(t),
  };
  return then(
    snapshot["id"]?.toString(),
    (String idString) => then(
      int.tryParse(idString),
      (int id) => then(
        snapshot["title"]?.toString(),
        (String title) => then(
          snapshot["desc"]?.toString(),
          (String desc) => then(
            DatabaseItemType.fromString(snapshot["type"]?.toString()),
            (DatabaseItemType type) => then(
              snapshot["contactName"]?.toString(),
              (String contactName) => then(
                snapshot["contactEmail"]?.toString(),
                (String contactEmail) => then(
                  formatDateTime(snapshot["beginPosting"]),
                  (DateTime beginPosting) => then(
                    formatDateTime(snapshot["endPosting"]),
                    (DateTime endPosting) => then(
                      formatDateTime(snapshot["date"]),
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
                          time: snapshot["time"]?.toString(),
                          location: snapshot["location"]?.toString(),
                          applyDeadline: formatDateTime(
                            snapshot["applyDeadline"],
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

DateTime? formatDateTime(dynamic dyn) => switch (dyn) {
    Timestamp timestamp => timestamp.toDate(),
    _ => null,
  };
