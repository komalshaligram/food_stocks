

class FormFieldValidation {

  emailField(String value) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }

  }

  String? validatePassword(String value) {
    RegExp regex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{0,}$');
    if (value.isEmpty) {
      return "Password can't be empty";
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password must have A-Z, a-z, 0-9 and min. one special characters';
      } else if (value.length < 8) {
        return 'Min. 8 characters required';
      } else {
        return null;
      }
    }
  }

  phoneNumField(String value) {
    RegExp regex = RegExp(
        r'(^\+{0,2}([\-\. ])?(\(?\d{0,3}\))?([\-\. ])?\(?\d{0,3}\)?([\-\. ])?\d{3}([\-\. ])?\d{4})');
    if (value.length < 10 || !regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }
  simpleTextField(String value) {
    if (value.isEmpty) {
      return 'enter value';
    } else {
      return null;

    }
  }
  simpleNumberField(String value) {
    if (value.isEmpty) {
      return 'enter value';
    } else {
      return null;
    }
  }

}
