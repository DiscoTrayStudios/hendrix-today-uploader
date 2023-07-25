import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hendrix_today_uploader/firebase/constants.dart';

typedef FirestoreRow = List<String?>;

Future<List<FirestoreRow>> getFirestoreContents() async {
  final db = FirebaseFirestore.instance;
  final items = <FirestoreRow>[];
  final querySnapshot = await db.collection(collectionName).get();
  for (final docSnapshot in querySnapshot.docs) {
    items.add(_formatDocSnapshot(docSnapshot.data()));
  }
  // sort by ID, with null/blank values first
  items.sort((a, b) => (int.tryParse(a[idField.index] ?? '') ?? -1)
      .compareTo(int.tryParse(b[idField.index] ?? '') ?? -1));
  return items;
}

FirestoreRow _formatDocSnapshot(Map<String, dynamic> snapshot) => [
      snapshot['id'],
      snapshot['title'],
      snapshot['desc'],
      snapshot['type'],
      snapshot['contactName'],
      snapshot['contactEmail'],
      _formatTimestamp(snapshot['beginPosting']),
      _formatTimestamp(snapshot['endPosting']),
      _formatTimestamp(snapshot['date']),
      snapshot['time'],
      snapshot['location'],
      _formatTimestamp(snapshot['applyDeadline']),
    ].map((dyn) => dyn?.toString()).toList();

String? _formatTimestamp(dynamic ts) {
  if (ts is! Timestamp) return ts?.toString();
  final dt = ts.toDate();
  final month = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][dt.month];
  return '${dt.year} $month ${dt.day}';
}
