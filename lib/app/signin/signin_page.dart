import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/app/signin/email_signin_page.dart';
import 'package:whereyouat/app/signin/signin_button.dart';
import 'package:whereyouat/app/signin/social_signin_button.dart';
import 'package:whereyouat/widgets/show_exception_alert_dialog.dart';
import '../../services/auth.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool _isLoading = false;

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  Future<void> signInAnonymously(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } on Exception catch (err) {
      _showSignInError(context, err);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    } on Exception catch (err) {
      _showSignInError(context, err);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithFacebook();
    } on Exception catch (err) {
      _showSignInError(context, err);
    } finally {
      setState(() {
        _isLoading = false;
      });
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
          SizedBox(
            child: _buildHeader(),
            height: 50,
          ),
          const SizedBox(
            height: 48,
          ),
          SocialSignInButton(
            asset: 'images/google-logo.png',
            color: Colors.white,
            textColor: Colors.black87,
            text: "Sign in with Google",
            onPressed:
                !_isLoading ? () => signInWithGoogle(context) : null,
          ),
          const SizedBox(
            height: 8,
          ),
          SocialSignInButton(
            asset: 'images/facebook-logo.png',
            color: const Color(0xff334d92),
            textColor: Colors.white,
            text: "Sign in with Facebook",
            onPressed:
                !_isLoading ? () => signInWithFacebook(context) : null,
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
            onPressed:
                !_isLoading ? () => signInAnonymously(context) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : const Text(
            "Sign in",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
          );
  }
}
