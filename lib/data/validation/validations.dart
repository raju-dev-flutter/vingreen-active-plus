class Validations {
  String? validateEmail(String value) {
    if (value.isEmpty || value.trim() == '') {
      return 'Please enter a valid email address here.';
    }
    final RegExp nameExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!nameExp.hasMatch(value)) {
      return 'Please enter a valid email address here.';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty || value.trim() == '') {
      return 'Please enter a valid password here.';
    } else if (value.length < 6) {
      return 'Password should have at least 6 characters.';
    }
    return null;
  }

  String? validateString(String value) {
    if (value.isEmpty || value.trim() == '') {
      return 'Please enter a valid data here.';
    }
    return null;
  }
}

//
// mixin InputValidationMixin {
//   bool isPasswordValid(String password) => password.length == 8;
//
//   bool isEmailValid(String email) {
//     // Pattern pattern =r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$' ;
//     RegExp regex = RegExp(
//         r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
//     return regex.hasMatch(email);
//   }
// }
