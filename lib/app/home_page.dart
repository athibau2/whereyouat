import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          FlatButton(
            child: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: _signOut,
          ),
        ],
      ),
    );
  }
}
