import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/app/signin/email_signin_page.dart';
import 'package:whereyouat/app/signin/signin_manager.dart';
import 'package:whereyouat/app/signin/signin_button.dart';
import 'package:whereyouat/app/signin/social_signin_button.dart';
import 'package:whereyouat/widgets/show_exception_alert_dialog.dart';
import '../../services/auth.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({Key? key, required this.isLoading, required this.manager})
      : super(key: key);
  final SigninManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SigninManager>(
          create: (_) => SigninManager(auth: auth, isLoading: isLoading),
          child: Consumer<SigninManager>(
            builder: (_, manager, __) => SigninPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

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
    try {
      await manager.signInAnonymously();
    } on Exception catch (err) {
      _showSignInError(context, err);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on Exception catch (err) {
      _showSignInError(context, err);
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on Exception catch (err) {
      _showSignInError(context, err);
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
        backgroundColor: Theme.of(context).primaryColor,
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: SvgPicture.asset(
        //     'images/logo.svg',
        //   ),
        // ),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 75,
          ),
          SizedBox(
            height: 150,
            child: SvgPicture.asset(
              'images/logo.svg',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            child: _buildHeader(),
          ),
          const SizedBox(
            height: 20,
          ),
          SocialSignInButton(
            asset: 'images/google-logo.png',
            color: Colors.white,
            textColor: Colors.black87,
            text: "Sign in with Google",
            onPressed: !isLoading ? () => signInWithGoogle(context) : null,
          ),
          const SizedBox(
            height: 8,
          ),
          SocialSignInButton(
            asset: 'images/facebook-logo.png',
            color: const Color(0xff334d92),
            textColor: Colors.white,
            text: "Sign in with Facebook",
            onPressed: !isLoading ? () => signInWithFacebook(context) : null,
          ),
          // const SizedBox(
          //   height: 8,
          // ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Or",
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
          ),
          SignInButton(
            color: Colors.teal[700],
            textColor: Colors.white,
            text: "Sign in with email",
            onPressed: !isLoading ? () => signInWithEmail(context) : null,
          ),
          // const Padding(
          //   padding: EdgeInsets.symmetric(vertical: 10),
          //   child: Text(
          //     "Or",
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          // SignInButton(
          //   color: Colors.lime[500],
          //   textColor: Colors.black87,
          //   text: "Continue as guest",
          //   onPressed: !isLoading ? () => signInAnonymously(context) : null,
          // ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : const SizedBox(
            height: 35,
          );
    // : Text(
    //     "Sign in",
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //         fontSize: 32,
    //         fontWeight: FontWeight.w600,
    //         color: Colors.grey.shade800,
    //         fontStyle: FontStyle.italic),
    //   );
  }
}
