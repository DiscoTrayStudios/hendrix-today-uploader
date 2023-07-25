import 'package:flutter/material.dart';

import 'package:hendrix_today_uploader/screens/main_menu.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  void _trySignIn(BuildContext context, String email, String password) {
    debugPrint('email: $email, password: $password');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const MainMenuScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final emailTEC = TextEditingController();
    final passwordTEC = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailTEC,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  hintText: 'someone@hendrix.edu',
                ),
              ),
              TextField(
                controller: passwordTEC,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: '•••',
                ),
                obscureText: true,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () =>
                      _trySignIn(context, emailTEC.text, passwordTEC.text),
                  child: const Text('Sign in (not yet implemented)'),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
