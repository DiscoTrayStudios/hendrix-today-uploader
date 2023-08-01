import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:hendrix_today_uploader/screens/main_menu.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key, this.message});
  final String? message;

  void _trySignIn(BuildContext context, String email, String password) {
    final auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(email: email, password: password).then((_) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MainMenuScreen()));
    }).catchError((e) {
      if (e is FirebaseAuthException) {
        _displaySignInError(context, e.message ?? 'Sign in failed');
      }
    });
  }

  void _displaySignInError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
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
              if (message != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(message!),
                ),
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
                onSubmitted: (_) =>
                    _trySignIn(context, emailTEC.text, passwordTEC.text),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () =>
                      _trySignIn(context, emailTEC.text, passwordTEC.text),
                  child: const Text('Sign in'),
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
