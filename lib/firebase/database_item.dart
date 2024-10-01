/// The different types of Hendrix Today items; this is directly related to the
/// Hendrix Today database schema.
enum DatabaseItemType {
  event,
  announcement,
  meeting;

  @override
  String toString() {
    switch (this) {
      case event:
        return "Event";
      case announcement:
        return "Announcement";
      case meeting:
        return "Meeting";
    }
  }

  /// Attempts to parse a [DatabaseItemType] from a [String].
  static DatabaseItemType? fromString(String? s) {
    switch (s?.trim().toLowerCase()) {
      case "event":
        return event;
      case "announcement":
        return announcement;
      case "meeting":
        return meeting;
      default:
        return null;
    }
  }
}

/// An object representing the Hendrix Today database schema.
final class DatabaseItem {
  DatabaseItem({
    required this.id,
    required this.title,
    required this.desc,
    required this.type,
    required this.contactName,
    required this.contactEmail,
    required this.beginPosting,
    required this.endPosting,
    required this.date,
    required this.time,
    required this.location,
    required this.applyDeadline,
  });
  final int id;
  final String title;
  final String desc;
  final DatabaseItemType type;
  final String contactName;
  final String contactEmail;
  final DateTime beginPosting;
  final DateTime endPosting;
  final DateTime date;
  final String? time;
  final String? location;
  final DateTime? applyDeadline;

  /// The number of fields a [DatabaseItem] has.
  static int fieldCount = fieldTitles.length;

  /// Descriptive labels for the fields of a [DatabaseItem]. Please don't change
  /// these.
  static List<String> get fieldTitles => [
      "ID",
      "Title",
      "Description",
      "Type",
      "Contact name",
      "Contact email",
      "First day to post",
      "Last day to post",
      "Date",
      "Time (optional)",
      "Location (optional)",
      "Application deadline (optional)",
    ];
  
  /// The types of the fields in a [DatabaseItem] in the same order and with the
  /// same length as [DatabaseItem.fieldTitles].
  static List<Type> get fieldTypes => [
      int,
      String,
      String,
      DatabaseItemType,
      String,
      String,
      DateTime,
      DateTime,
      DateTime,
      String,
      String,
      DateTime,
    ];

  /// The contents of this [DatabaseItem] in the same order and with the same 
  /// length as [DatabaseItem.fieldTitles].
  List<dynamic> get fieldContents => [
      id,
      title,
      desc,
      type,
      contactName,
      contactEmail,
      beginPosting,
      endPosting,
      date,
      time,
      location,
      applyDeadline,
    ];
  
  /// Does this [DatabaseItem] have all the same field data as [other]?
  bool equals(DatabaseItem other) =>
    id == other.id &&
    title == other.title &&
    desc == other.desc &&
    type == other.type &&
    contactName == other.contactName &&
    contactEmail == other.contactEmail &&
    beginPosting == other.beginPosting &&
    endPosting == other.endPosting &&
    date == other.date &&
    time == other.time &&
    location == other.location &&
    applyDeadline == other.applyDeadline;

  @override
  String toString() =>
    "DatabaseItem("
    "id=$id, "
    "title='$title',"
    "desc='$desc',"
    "type=$type,"
    "contactName='$contactName',"
    "conatactEmail='$contactEmail',"
    "beginPosting=$beginPosting,"
    "endPosting=$endPosting,"
    "date=$date,"
    "time=${switch (time) { null => "null", String t => "'$t'"}},"
    "location=${switch (location) { null => "null", String l => "'$l'"}},"
    "applyDeadline=${applyDeadline ?? "null"})";

  /// A compact standardized date format: YYYY-MMM-D, in which MMM is a three-
  /// letter abbreviation of the month's English name, and D is the numeric day
  /// with no leading zeroes.
  static String formatDate(DateTime dt) {
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

  /// Attempts to undo the string formatting used on dates.
  static DateTime? undoFormatDate(String? field) {
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
}