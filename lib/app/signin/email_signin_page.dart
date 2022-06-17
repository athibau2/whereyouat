import 'package:flutter/material.dart';
import 'package:whereyouat/app/signin/email_signin_form_bloc_based.dart';

import '../../services/auth.dart';
import 'email_signin_form_stateful.dart';

class EmailSigninPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign in"),
        elevation: 6,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: EmailSigninFormBlocBased.create(context),
            )),
      ),
    );
  }
}
