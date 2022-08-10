import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/app/home/home_page.dart';
import 'package:whereyouat/app/signin/signin_page.dart';
import 'package:whereyouat/services/database.dart';
import '../services/auth.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      // initialData parameter is an option to pass in, instead of checking the connection state
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null
              ? SigninPage.create(context)
              : Provider<Database>(
                  create: (_) => FirestoreDatabase(uid: user.uid),
                  builder: (context, child) {
                    return const HomePage();
                  },
                );
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
