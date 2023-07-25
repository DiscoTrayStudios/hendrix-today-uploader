import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:hendrix_today_uploader/objects/excel_data.dart';
import 'package:hendrix_today_uploader/firebase/upload.dart';
import 'package:hendrix_today_uploader/widgets/excel_table.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key, required this.excel});
  final ExcelData excel;

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  bool _uploadLoading = false;

  void _tryUpload() async {
    if (_uploadLoading) return; // already in progress
    final List<UploadResult> results = [];
    setState(() {
      _uploadLoading = true;
    });
    for (final row in widget.excel.rows) {
      final result = await uploadToFirestore(row);
      results.add(result);
      if (result.type == UploadResultType.permissionDenied) break;
    }
    setState(() {
      _uploadLoading = false;
    });
    _displayResults(results);
  }

  void _displayResults(List<UploadResult> results) {
    final invalidFields = results
        .where((result) => result.type == UploadResultType.invalidFields);
    if (invalidFields.isNotEmpty) {
      String displayIDs = invalidFields
          .map((result) => result.snapshot.get(idColumn))
          .join(', ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'The following rows (by ID) are improperly formatted or missing '
            'required data: $displayIDs'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
    final unknownErrors =
        results.where((result) => result.type == UploadResultType.unknownError);
    if (unknownErrors.isNotEmpty) {
      String displayIDs = unknownErrors
          .map((result) => result.snapshot.get(idColumn))
          .join(', ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'An unknown error occurred trying to upload the following rows (by '
            'ID): $displayIDs'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
    if (results
        .any((result) => result.type == UploadResultType.permissionDenied)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
            'You do not have upload permission. Please sign in or contact the '
            'maintainer of this upload tool.'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
    final successfulInserts = results
        .where((result) => result.type == UploadResultType.successfulInsert);
    if (successfulInserts.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully created ${successfulInserts.length} new '
            'item${successfulInserts.length != 1 ? 's' : ''}!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ));
    }
    final successfulUpdates = results
        .where((result) => result.type == UploadResultType.successfulUpdate);
    if (successfulUpdates.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully updated ${successfulUpdates.length} '
            'item${successfulUpdates.length != 1 ? 's' : ''}!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload File'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _tryUpload,
                  child:
                      Text(_uploadLoading ? 'Uploading...' : 'Upload to App'),
                ),
              ),
              const _LinkReminderText(),
            ],
          ),
          ExcelTable(excel: widget.excel),
        ],
      ),
    );
  }
}

class _LinkReminderText extends StatelessWidget {
  const _LinkReminderText();

  void _openLinkFormatter() {
    launchUrl(Uri.parse('https://wtools.io/html-link-generator'));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                  text: 'Remember to add links to descriptions as necessary '
                      'using an HTML link creator '),
              TextSpan(
                  text: 'like this one',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = _openLinkFormatter),
              const TextSpan(
                  text: '. The end result should look like, "Click <a href='
                      '"https://hendrix.edu">here</a> to learn more."'),
            ],
          ),
        ),
      ),
    );
  }
}
