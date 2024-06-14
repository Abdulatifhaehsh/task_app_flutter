class Validators {
  static bool isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegExp.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
}
