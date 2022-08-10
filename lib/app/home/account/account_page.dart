import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/services/auth.dart';
import 'package:whereyouat/services/database.dart';
import 'package:whereyouat/widgets/avatar.dart';
import 'package:whereyouat/widgets/custom_button.dart';
import 'package:whereyouat/widgets/show_alert_dialog.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteAccount(auth.currentUser!.uid);
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        cancelActionText: 'Cancel',
        defaultActionText: 'Logout');

    if (didRequestSignOut == true) _signOut(context);
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final didRequestDeleteAccount = await showAlertDialog(context,
        title: 'Delete Account',
        content: 'Are you sure you want to delete your account?',
        cancelActionText: 'Cancel',
        defaultActionText: 'Delete');

    if (didRequestDeleteAccount == true) _deleteAccount(context);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 6,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: SvgPicture.asset(
            'images/logo.svg',
          ),
        ),
        title: const Text("Account"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () => _confirmSignOut(context),
            tooltip: 'Logout',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(auth.currentUser),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              auth.currentUser!.toString(),
              style: const TextStyle(color: Colors.black),
            ),
            CustomButton(
              child: const Text(
                'Delete Account',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.redAccent,
              onPressed: () => _confirmDeleteAccount(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(User? user) {
    return Column(
      children: [
        Avatar(
          photoUrl: user!.photoURL,
          radius: 50,
        ),
        const SizedBox(
          height: 8,
        ),
        if (user.displayName != null)
          Text(
            user.displayName!,
            style: const TextStyle(color: Colors.white),
          ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
