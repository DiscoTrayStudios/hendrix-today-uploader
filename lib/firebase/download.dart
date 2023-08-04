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

DateTime? undoFormatDate(String? field) {
  if (field == null) return null;
  final formattedString = field
      // replace month names with numbers
      .replaceFirst('Jan', '01')
      .replaceFirst('Feb', '02')
      .replaceFirst('Mar', '03')
      .replaceFirst('Apr', '04')
      .replaceFirst('May', '05')
      .replaceFirst('Jun', '06')
      .replaceFirst('Jul', '07')
      .replaceFirst('Aug', '08')
      .replaceFirst('Sep', '09')
      .replaceFirst('Oct', '10')
      .replaceFirst('Nov', '11')
      .replaceFirst('Dec', '12')
      // left-pad single-digit day values with a 0
      .replaceFirst(RegExp(r' 1$'), '01')
      .replaceFirst(RegExp(r' 2$'), '02')
      .replaceFirst(RegExp(r' 3$'), '03')
      .replaceFirst(RegExp(r' 4$'), '04')
      .replaceFirst(RegExp(r' 5$'), '05')
      .replaceFirst(RegExp(r' 6$'), '06')
      .replaceFirst(RegExp(r' 7$'), '07')
      .replaceFirst(RegExp(r' 8$'), '08')
      .replaceFirst(RegExp(r' 9$'), '09')
      // replace spaces with hyphens
      .replaceAll(' ', '-');
  return DateTime.tryParse(formattedString);
}
