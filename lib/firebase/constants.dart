/// The name of the Firestore collection to which to push updates.
const collectionName = 'events';

typedef ExcelField = ({int column, String name});

// Need to add HIP here TODO
const ExcelField idField = (column: 0, name: 'ID'); // 0
const ExcelField contactNameField = (column: 1, name: 'Contact name'); // 1
const ExcelField contactEmailField = (column: 2, name: 'Contact email'); // 2
// ignore phone number
const ExcelField typeField = (column: 4, name: 'Type'); // 4
const ExcelField titleField = (column: 5, name: 'Title'); // 5
const ExcelField dateField = (column: 6, name: 'Date'); // 6
const ExcelField timeField = (column: 7, name: 'Time (optional)'); // 7
const ExcelField locationField = (column: 8, name: 'Location (optional)'); // 8
const ExcelField descField = (column: 9, name: 'Description'); // 9
// ignore hyperlinks, these are fixed by people
const ExcelField hipField = (column: 11, name: 'HIP'); // 11
const ExcelField beginPostingField =
    (column: 12, name: 'First day to post'); // 12
const ExcelField endPostingField = (column: 13, name: 'Last day to post'); // 13
const ExcelField applyDeadlineField =
    (column: 14, name: 'Application deadline (optional)'); // 14

/// A list of [ExcelField]s for each field an item can have.
///
/// The `column` of each field corresponds to the 0-indexed column of the
/// submission form's Excel output at which the associated field data exists.
final orderedFields = List<ExcelField>.unmodifiable(const [
  idField,
  contactNameField,
  contactEmailField,
  typeField,
  titleField,
  dateField,
  timeField,
  locationField,
  descField,
  hipField,
  beginPostingField,
  endPostingField,
  applyDeadlineField,
]);
