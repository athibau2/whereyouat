import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/app/signin/email_signin_page.dart';
import 'package:whereyouat/app/signin/signin_button.dart';
import 'package:whereyouat/app/signin/social_signin_button.dart';
import '../../services/auth.dart';

class SigninPage extends StatelessWidget {
  Future<void> signInAnonymously(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithFacebook();
    } catch (err) {
      print(err.toString());
    }
  }

  void signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => EmailSigninPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Where You At"),
        elevation: 6,
        centerTitle: true,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey.shade200,
    );
  }

  Widget _buildContent(BuildContext context) {
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
            onPressed: () => signInWithGoogle(context),
          ),
          const SizedBox(
            height: 8,
          ),
          SocialSignInButton(
            asset: 'images/facebook-logo.png',
            color: const Color(0xff334d92),
            textColor: Colors.white,
            text: "Sign in with Facebook",
            onPressed: () => signInWithFacebook(context),
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButton(
            color: Colors.teal[700],
            textColor: Colors.white,
            text: "Sign in with email",
            onPressed: () => signInWithEmail(context),
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
            onPressed: () => signInAnonymously(context),
          ),
        ],
      ),
    );
  }
}
