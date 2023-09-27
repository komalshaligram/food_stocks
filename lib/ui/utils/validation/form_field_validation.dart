import 'package:food_stock/ui/utils/themes/app_strings.dart';

class FormFieldValidation {
  String? emailField(String value) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value.isEmpty) {
      return "Email can't be empty";
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid email';
      } else {
        return null;
      }
    }
  }

  phoneNumField(String value) {
    RegExp regex = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if (value.length < 10 || !regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  String? simpleTextField(String value) {
    if (value.isEmpty) {
      return 'enter value';
    } else {
      return null;
    }
  }

  String? simpleNumberField(String value) {
    if (value.isEmpty) {
      return 'enter value';
    } else {
      return null;
    }
  }

  String? businessNameField(String value) {
    if (value.isEmpty) {
      return 'Enter your business name';
    }
    return null;
  }

  String? hpField(String value) {
    RegExp regex = RegExp(r'^(?=.*?[0-9]).{0,}$');
    if (value.isEmpty) {
      return "hp can't be empty";
    } else if (!regex.hasMatch(value)) {
      return "Enter valid H.P.";
    }
    return null;
  }

  String? ownerNameField(String value) {
    if (value.isEmpty) {
      return 'Enter business owner name';
    }
    return null;
  }

  String? idField(String value) {
    if (value.isEmpty) {
      return "Id can't be empty";
    }
    return null;
  }

  String? contactNameField(String value) {
    if (value.isEmpty) {
      return "Enter contact name";
    }
    return null;
  }

  String? addressNameField(String value) {
    if (value.isEmpty) {
      return "Address can't be empty";
    }
    return null;
  }

  String? faxField(String value) {
    RegExp regex = RegExp(r'^(?=.*?[0-9]).{0,}$');
    if (value.isEmpty) {
      return "Fax number can't be empty";
    } else if (!regex.hasMatch(value)) {
      return "Enter valid FAX number";
    }
    return null;
  }
}
