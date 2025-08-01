/// The name of the Firestore collection to which to push updates.
const collectionName = 'events';

typedef ExcelField = ({int column, String name});

// Need to add HIP here TODO
const ExcelField idField = (column: 0, name: 'ID');
const ExcelField titleField = (column: 8, name: 'Title');
const ExcelField descField = (column: 15, name: 'Description');
const ExcelField typeField = (column: 11, name: 'Type');
const ExcelField contactNameField = (column: 6, name: 'Contact name');
const ExcelField contactEmailField = (column: 7, name: 'Contact email');
const ExcelField beginPostingField = (column: 9, name: 'First day to post');
const ExcelField endPostingField = (column: 10, name: 'Last day to post');
const ExcelField dateField = (column: 12, name: 'Date');
const ExcelField timeField = (column: 14, name: 'Time (optional)');
const ExcelField locationField = (column: 17, name: 'Location (optional)');
const ExcelField applyDeadlineField =
    (column: 13, name: 'Application deadline (optional)');

/// A list of [ExcelField]s for each field an item can have.
///
/// The `column` of each field corresponds to the 0-indexed column of the
/// submission form's Excel output at which the associated field data exists.
final orderedFields = List<ExcelField>.unmodifiable(const [
  // ALSO NEED HIP HERE TODO
  idField,
  titleField,
  descField,
  typeField,
  contactNameField,
  contactEmailField,
  beginPostingField,
  endPostingField,
  dateField,
  timeField,
  locationField,
  applyDeadlineField,
]);
