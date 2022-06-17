import 'package:flutter/material.dart';
import 'package:whereyouat/app/signin/validators.dart';
import '../../services/auth.dart';
import 'email_signin_model.dart';

class EmailSigninChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSigninChangeModel(
      {required this.auth,
      this.email = '',
      this.password = '',
      this.confirmPassword = '',
      this.formType = EmailSigninFormType.signIn,
      this.isLoading = false,
      this.submitted = false});
  final AuthBase auth;
  String email;
  String password;
  String confirmPassword;
  EmailSigninFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSigninFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == EmailSigninFormType.signIn ? 'Sign In' : 'Register';
  }

  String get secondaryButtonText {
    return formType == EmailSigninFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSignIn {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  bool get canRegister {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        confirmPasswordValidator.isValid(confirmPassword) &&
        !isLoading;
  }

  bool get validator {
    return formType == EmailSigninFormType.register ? canRegister : canSignIn;
  }

  String? get confirmPasswordErrorText {
    bool showErrorText = submitted &&
        !confirmPasswordValidator.passwordMatch(password, confirmPassword);
    return showErrorText ? invalidConfirmPasswordErrorText : null;
  }

  String? get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void toggleFormType() {
    final formType = this.formType == EmailSigninFormType.signIn
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
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.confirmPassword = confirmPassword ?? this.confirmPassword;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
