import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whereyouat/app/signin/signin_button.dart';
import 'package:whereyouat/app/signin/social_signin_button.dart';
import 'package:whereyouat/widgets/custom_button.dart';

import '../../services/auth.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({Key? key, this.auth}) : super(key: key);
  final AuthBase? auth;

  Future<void> signInAnonymously() async {
    try {
      await auth!.signInAnonymously();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await auth!.signInWithGoogle();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      await auth!.signInWithFacebook();
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Where You At"),
        elevation: 6,
        centerTitle: true,
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey.shade200,
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Sign in",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 48,
          ),
          SocialSignInButton(
            asset: 'images/google-logo.png',
            color: Colors.white,
            textColor: Colors.black87,
            text: "Sign in with Google",
            onPressed: signInWithGoogle,
          ),
          const SizedBox(
            height: 8,
          ),
          // SocialSignInButton(
          //   asset: 'images/facebook-logo.png',
          //   color: const Color(0xff334d92),
          //   textColor: Colors.white,
          //   text: "Sign in with Facebook",
          //   onPressed: signInWithFacebook,
          // ),
          // const SizedBox(
          //   height: 8,
          // ),
          SignInButton(
            color: Colors.teal[700],
            textColor: Colors.white,
            text: "Sign in with email",
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Or",
              textAlign: TextAlign.center,
            ),
          ),
          SignInButton(
            color: Colors.lime[500],
            textColor: Colors.black87,
            text: "Continue as guest",
            onPressed: signInAnonymously,
          ),
        ],
      ),
    );
  }
}
