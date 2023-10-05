

class FormFieldValidation {
  String? emailField(String value) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value.isEmpty) {
      return "email can't be empty";
    } else {
      if (!regex.hasMatch(value)) {
        return 'enter valid email';
      } else {
        return null;
      }
    }
  }

  // phoneNumField(String value) {
  //   RegExp regex = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
  //   if (value.length < 10 || !regex.hasMatch(value)) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  String? mobileField(String value) {
    RegExp regex = RegExp(r'^(?=.*?[0-9]).{10}$');
    if (value.trim().isEmpty) {
      return "mobile can't be Empty";
    } else if(!regex.hasMatch(value)) {
      return "enter digits only";
    } else if (value.length < 10 || value.length > 10) {
      return "mobile must be 10 digit";
    } else {
      return null;
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
      return 'enter your business name';
    }
    return null;
  }

  String? hpField(String value) {
    RegExp regex = RegExp(r'^(?=.*?[0-9]).{0,}$');
    if (value.isEmpty) {
      return "hp can't be empty";
    } else if (!regex.hasMatch(value)) {
      return "enter valid H.P.";
    }
    return null;
  }

  String? ownerNameField(String value) {
    if (value.isEmpty) {
      return 'enter business owner name';
    }
    return null;
  }

  String? idField(String value) {
    RegExp regex = RegExp(r'^(?=.*?[0-9]).{0,}$');
    if (value.isEmpty) {
      return "id can't be empty";
    } else if(!regex.hasMatch(value)) {
      return "enter digits only";
    }
    return null;
  }

  String? contactNameField(String value) {
    if (value.isEmpty) {
      return "enter contact name";
    }
    return null;
  }

  String? addressNameField(String value) {
    if (value.isEmpty) {
      return "address can't be empty";
    }
    return null;
  }

  String? faxField(String value) {
    RegExp regex = RegExp(r'^(?=.*?[0-9]).{0,}$');
    if (value.isEmpty) {
      return "fax number can't be empty";
    } else if (!regex.hasMatch(value)) {
      return "enter valid fax number";
    }
    return null;
  }
}
