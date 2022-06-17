import 'package:whereyouat/app/signin/validators.dart';

enum EmailSigninFormType { signIn, register }

class EmailSigninModel with EmailAndPasswordValidators {
  EmailSigninModel(
      {this.email = '',
      this.password = '',
      this.confirmPassword = '',
      this.formType = EmailSigninFormType.signIn,
      this.isLoading = false,
      this.submitted = false});
  final String email;
  final String password;
  final String confirmPassword;
  final EmailSigninFormType formType;
  final bool isLoading;
  final bool submitted;

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

  EmailSigninModel copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    EmailSigninFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSigninModel(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
