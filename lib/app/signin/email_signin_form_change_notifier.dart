import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/app/signin/email_signin_bloc.dart';
import 'package:whereyouat/widgets/form_submit_button.dart';
import '../../services/auth.dart';
import '../../widgets/show_exception_alert_dialog.dart';
import 'email_signin_change_model.dart';
import 'email_signin_model.dart';

class EmailSigninFormChangeNotifier extends StatefulWidget {
  const EmailSigninFormChangeNotifier({Key? key, required this.model})
      : super(key: key);
  final EmailSigninChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSigninChangeModel>(
      create: (_) => EmailSigninChangeModel(auth: auth),
      child: Consumer<EmailSigninChangeModel>(
        builder: (_, model, __) => EmailSigninFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  State<EmailSigninFormChangeNotifier> createState() =>
      _EmailSigninFormChangeNotifierState();
}

class _EmailSigninFormChangeNotifierState
    extends State<EmailSigninFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  EmailSigninChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  List<Widget> _buildChildren() {
    return <Widget>[
      _buildEmailField(),
      const SizedBox(
        height: 5,
      ),
      _buildPasswordField(),
      if (model.formType == EmailSigninFormType.register)
        const SizedBox(
          height: 5,
        ),
      if (model.formType == EmailSigninFormType.register)
        _buildConfirmPasswordField(),
      const SizedBox(
        height: 20,
      ),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.validator ? _submit : null,
      ),
      const SizedBox(
        height: 10,
      ),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildConfirmPasswordField() {
    return TextField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        errorText: model.confirmPasswordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      onChanged: model.updateConfirmPassword,
    );
  }

  TextField _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: model.updatePassword,
    );
  }

  TextField _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'example@email.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: model.updateEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
