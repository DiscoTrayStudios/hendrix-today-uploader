import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:hendrix_today_uploader/objects/excel_data.dart';
import 'package:hendrix_today_uploader/objects/upload_item.dart';
import 'package:hendrix_today_uploader/widgets/excel_table.dart';

class UploadFileScreen extends StatelessWidget {
  const UploadFileScreen({super.key, required this.excel});
  final ExcelData excel;

  void _tryUpload(BuildContext context) async {
    final List<UploadItem> uploadItems = [];
    final List<String?> badItemIDs = [];
    for (final row in excel.rows) {
      final newItem = UploadItem.fromExcelRow(row);
      if (newItem != null) {
        uploadItems.add(newItem);
      } else {
        badItemIDs.add(row[idColumn]);
      }
    }
    if (badItemIDs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The following rows (by ID) are missing required data: '
              '${badItemIDs.join(', ')}.'),
          backgroundColor: Theme.of(context).colorScheme.error));
    } else {
      for (final item in uploadItems) {
        item.uploadToFirestore();
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Successfully uploaded ${uploadItems.length} items to the '
                'database!'),
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
                  onPressed: () => _tryUpload(context),
                  child: const Text('Upload to App'),
                ),
              ),
              const _LinkReminderText(),
            ],
          ),
          ExcelTable(excel: excel),
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
