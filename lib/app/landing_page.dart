import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whereyouat/app/home_page.dart';
import 'package:whereyouat/app/signin/signin_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late User? _user;

  void _updateUser(dynamic user) {
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateUser(FirebaseAuth.instance.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return _user == null
        ? SigninPage(
            onSignIn: _updateUser,
          )
        : HomePage(onSignOut: () => _updateUser(null));
  }
}
