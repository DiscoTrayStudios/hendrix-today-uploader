/// The name of the Firestore collection to which to push updates.
const collectionName = 'events';

typedef FieldRecord = ({int index, String name});

const FieldRecord idField = (index: 0, name: 'ID');
const FieldRecord titleField = (index: 8, name: 'Title');
const FieldRecord descField = (index: 15, name: 'Description');
const FieldRecord typeField = (index: 11, name: 'Type');
const FieldRecord contactNameField = (index: 6, name: 'Contact name');
const FieldRecord contactEmailField = (index: 7, name: 'Contact email');
const FieldRecord beginPostingField = (index: 9, name: 'First day to post');
const FieldRecord endPostingField = (index: 10, name: 'Last day to post');
const FieldRecord dateField = (index: 12, name: 'Date');
const FieldRecord timeField = (index: 14, name: 'Time (optional)');
const FieldRecord locationField = (index: 17, name: 'Location (optional)');
const FieldRecord applyDeadlineField =
    (index: 13, name: 'Application deadline (optional)');

/// A list of [FieldRecord]s for each field an item can have.
///
/// The `index` of each field corresponds to the column index of the submission
/// form's Excel output at which the associated field data exists (where column
/// A = 0).
final orderedFields = List<FieldRecord>.unmodifiable(const [
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
