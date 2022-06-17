import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whereyouat/app/signin/email_signin_bloc.dart';
import 'package:whereyouat/widgets/form_submit_button.dart';
import '../../services/auth.dart';
import '../../widgets/show_exception_alert_dialog.dart';
import 'email_signin_model.dart';

class EmailSigninFormBlocBased extends StatefulWidget {
  EmailSigninFormBlocBased({Key? key, required this.bloc}) : super(key: key);
  final EmailSigninBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSigninBloc>(
      create: (_) => EmailSigninBloc(auth: auth),
      child: Consumer<EmailSigninBloc>(
        builder: (_, bloc, __) => EmailSigninFormBlocBased(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<EmailSigninFormBlocBased> createState() =>
      _EmailSigninFormBlocBasedState();
}

class _EmailSigninFormBlocBasedState extends State<EmailSigninFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
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
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  List<Widget> _buildChildren(EmailSigninModel model) {
    return <Widget>[
      _buildEmailField(model),
      const SizedBox(
        height: 5,
      ),
      _buildPasswordField(model),
      if (model.formType == EmailSigninFormType.register)
        const SizedBox(
          height: 5,
        ),
      if (model.formType == EmailSigninFormType.register)
        _buildConfirmPasswordField(model),
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

  TextField _buildConfirmPasswordField(EmailSigninModel model) {
    return TextField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        errorText: model.confirmPasswordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      onChanged: widget.bloc.updateConfirmPassword,
    );
  }

  TextField _buildPasswordField(EmailSigninModel model) {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: widget.bloc.updatePassword,
    );
  }

  TextField _buildEmailField(EmailSigninModel model) {
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
      onChanged: widget.bloc.updateEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSigninModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSigninModel(),
        builder: (context, snapshot) {
          final EmailSigninModel model = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(model),
            ),
          );
        });
  }
}
