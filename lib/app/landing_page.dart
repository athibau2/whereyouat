import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whereyouat/app/home_page.dart';
import 'package:whereyouat/app/signin/signin_page.dart';

import '../services/auth.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      // initialData parameter is an option to pass in, instead of checking the connection state
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null
              ? SigninPage(auth: auth)
              : HomePage(auth: auth);
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
