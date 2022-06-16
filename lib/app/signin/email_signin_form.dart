import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/app/signin/validators.dart';
import 'package:whereyouat/widgets/form_submit_button.dart';
import '../../services/auth.dart';
import '../../widgets/show_exception_alert_dialog.dart';

enum EmailSigninFormType { signIn, register }

class EmailSigninForm extends StatefulWidget with EmailAndPasswordValidators {
  @override
  State<EmailSigninForm> createState() => _EmailSigninFormState();
}

class _EmailSigninFormState extends State<EmailSigninForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _submitted = false;
  bool _isLoading = false;

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  String get _confirmPassword => _confirmPasswordController.text;

  EmailSigninFormType _formType = EmailSigninFormType.signIn;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSigninFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSigninFormType.signIn
          ? EmailSigninFormType.register
          : EmailSigninFormType.signIn;
      _submitted = false;
    });
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailSigninFormType.signIn ? 'Sign In' : 'Register';
    final secondaryText = _formType == EmailSigninFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    bool _signinEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;
    bool _registerEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        widget.confirmPasswordValidator.isValid(_confirmPassword) &&
        !_isLoading;
    bool _validator = _formType == EmailSigninFormType.register
        ? _registerEnabled
        : _signinEnabled;

    return <Widget>[
      _buildEmailField(),
      const SizedBox(
        height: 5,
      ),
      _buildPasswordField(),
      if (_formType == EmailSigninFormType.register)
        const SizedBox(
          height: 5,
        ),
      if (_formType == EmailSigninFormType.register)
        _buildConfirmPasswordField(),
      const SizedBox(
        height: 20,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: _validator ? _submit : null,
      ),
      const SizedBox(
        height: 10,
      ),
      FlatButton(
        child: Text(secondaryText),
        onPressed: !_isLoading ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildConfirmPasswordField() {
    bool showErrorText = _submitted &&
        !widget.confirmPasswordValidator
            .passwordMatch(_password, _confirmPassword);
    return TextField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        errorText:
            showErrorText ? widget.invalidConfirmPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      onChanged: (confirmPassword) => _updateState(),
    );
  }

  TextField _buildPasswordField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);

    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) => _updateState(),
    );
  }

  TextField _buildEmailField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);

    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'example@email.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
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

  _updateState() {
    setState(() {});
  }
}
