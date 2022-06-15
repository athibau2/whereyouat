abstract class StringValidator {
  bool isValid(String value);
  bool passwordMatch(String pass1, String pass2);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }

  @override
  bool passwordMatch(String pass1, String pass2) {
    return pass1 == pass2;
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final StringValidator confirmPasswordValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = 'Email can\'t be empty';
  final String invalidPasswordErrorText = 'Password can\'t be empty';
  final String invalidConfirmPasswordErrorText = 'Passwords must match';
}
