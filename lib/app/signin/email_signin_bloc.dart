import 'dart:async';

import 'package:whereyouat/app/signin/email_signin_form_stateful.dart';
import 'package:whereyouat/app/signin/email_signin_model.dart';

import '../../services/auth.dart';

class EmailSigninBloc {
  EmailSigninBloc({required this.auth});
  final AuthBase auth;
  final StreamController<EmailSigninModel> _modelController =
      StreamController<EmailSigninModel>();

  Stream<EmailSigninModel> get modelStream => _modelController.stream;
  EmailSigninModel _model = EmailSigninModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSigninFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleFormType() {
    final formType = _model.formType == EmailSigninFormType.signIn
          ? EmailSigninFormType.register
          : EmailSigninFormType.signIn;
    updateWith(
      email: '',
      password: '',
      confirmPassword: '',
      isLoading: false,
      submitted: false,
      formType: formType,
    );
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void updateConfirmPassword(String confirmPassword) =>
      updateWith(confirmPassword: confirmPassword);

  void updateWith({
    String? email,
    String? password,
    String? confirmPassword,
    EmailSigninFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    // update model
    _model = _model.copyWith(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    // add updated model to _modelController
    _modelController.add(_model);
  }
}
