import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import 'package:hendrix_today_uploader/objects/excel_data.dart';
import 'package:hendrix_today_uploader/screens/sign_in.dart';
import 'package:hendrix_today_uploader/screens/upload_file.dart';
import 'package:hendrix_today_uploader/screens/view_databse.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  void _selectExcelFile() async {
    final pickedResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ["xlsx"],
      allowMultiple: false,
    );
    if (pickedResult == null) return;
    if (!pickedResult.isSinglePick) return;
    if (pickedResult.files.single.extension != "xlsx") return;
    final bytes = pickedResult.files.single.bytes;
    if (bytes == null) return;
    try {
      final excel = Excel.decodeBytes(bytes.toList());
      _goToExcelViewPage(excel);
    } catch (_) {
      _showBadFilePopup();
    }
  }

  void _goToExcelViewPage(Excel excel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UploadFileScreen(excel: ExcelData(excel))));
  }

  void _goToDatabaseViewPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DatabaseViewScreen()));
  }

  void _resetPassword() {
    final auth = FirebaseAuth.instance;
    auth.sendPasswordResetEmail(email: auth.currentUser!.email!);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => SignInScreen(
              message: 'A password reset email has been sent to '
                  '${auth.currentUser!.email!}. Look for an email from '
                  'noreply@hendrix-today-app.firebaseapp.com; check your spam '
                  'folder if it does not show up.')),
    );
  }

  void _signOut() {
    FirebaseAuth.instance.signOut().then((_) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        ));
  }

  void _showBadFilePopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Bad File!"),
        content: const Text(
            "There was something wrong with that file, so it can't be used. "
            "Please choose a different file."),
        actions: [
          TextButton(
            child: const Text("Ok"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hendrix Today Uploader"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 10),
            const Text("Editorial"),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectExcelFile,
              child: const Text("Select an Excel file to upload"),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _goToDatabaseViewPage,
              child: const Text("View the database"),
            ),
            const Spacer(flex: 2),
            const Text("User"),
            const Spacer(),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text("Reset password"),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _signOut,
              child: const Text("Sign out"),
            ),
            const Spacer(flex: 10),
          ],
        ),
      ),
    );
  }
}
