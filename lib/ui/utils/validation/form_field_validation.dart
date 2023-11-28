class FormFieldValidation {
  String? emailField(String value) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value.isEmpty) {
      return "Please enter email";
    } else {
      if (!regex.hasMatch(value)) {
        return 'Please enter valid email';
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
    RegExp regex = RegExp(r"^(?=.*?[a-zA-Z.!#$%&'*+-/=?^_`{|}~]).*$");
    if (value.trim().isEmpty) {
      return "Phone number can't be Empty";
    } else if (value.length <= 10) {
      if (regex.hasMatch(value)) {
        return "Please enter valid phone number";
      }
      else if(value.length < 10){
        return "Phone number must be 10-digit";
      }
      else{
        return null;
      }
    } else if (value.length > 10) {
      return "Phone number must be 10-digit";
    }
    else {
      return null;
    }
  }

  String? simpleTextField(String value) {
    if (value.isEmpty) {
      return 'Please enter value';
    } else {
      return null;
    }
  }

  String? simpleNumberField(String value) {
    if (value.isEmpty) {
      return 'Please enter value';
    } else {
      return null;
    }
  }

  String? businessNameField(String value) {
    RegExp regex = RegExp(r"^(?=.*?[0-9.!#$%&'*₹+-/=?^_`{|}~]).*$");
    RegExp regex1 = RegExp(r"^(?=.*?[a-zA-z]).*$");
    if (value.isEmpty) {
      return 'Please enter your business name';
    } else if (regex.hasMatch(value)) {
      return 'Please enter alphabets only';
    } else if (!regex1.hasMatch(value)) {
      return 'Please enter valid business name';
    }
    return null;
  }

  String? hpField(String value) {
    RegExp regex = RegExp(r'^(?=.*?[0-9]).{0,}$');
    if (value.isEmpty) {
      return "Please enter business ID";
    } else if (!regex.hasMatch(value)) {
      return "Please enter valid business ID";
    }
    return null;
  }

  String? ownerNameField(String value) {
    RegExp regex = RegExp(r"^(?=.*?[0-9.!#$%&'*+-/=?^_`{|}~]).*$");
    RegExp regex1 = RegExp(r"^(?=.*?[a-zA-z]).*$");
    if (value.isEmpty) {
      return 'Please enter owner name';
    } else if (regex.hasMatch(value)) {
      return 'Please enter alphabets only';
    } else if (!regex1.hasMatch(value)) {
      return 'Please enter valid owner name';
    }
    return null;
  }

  String? idField(String value) {
    RegExp regex = RegExp(r'^(?=.*?[0-9]).{0,}$');
    if (value.isEmpty) {
      return "Please enter israel ID";
    } else if (!regex.hasMatch(value)) {
      return "Please enter valid israel ID";
    }
    return null;
  }

  String? contactNameField(String value) {
    RegExp regex = RegExp(r"^(?=.*?[0-9.!#$%&'*₹+-/=?^_`{|}~]).*$");
    RegExp regex1 = RegExp(r"^(?=.*?[a-zA-z]).*$");
    if (value.isEmpty) {
      return "Please enter contact name";
    } else if (regex.hasMatch(value)) {
      return 'Enter alphabets only';
    } else if (!regex1.hasMatch(value)) {
      return 'Please enter valid contact name';
    }
    return null;
  }

  String? addressNameField(String value) {
    RegExp regex = RegExp(r"^(?=.*?[!#$%&'*@<>:)(;₹+=?^_`{|}~]).*$");
    RegExp regex1 = RegExp(r"^(?=.*?[a-zA-z]).*$");
    if (value.isEmpty) {
      return "Please enter address";
    } else if (regex.hasMatch(value)) {
      return "Please enter valid address";
    } else if (!regex1.hasMatch(value)) {
      return 'Please enter valid address';
    }
    return null;
  }

  String? faxField(String value) {
    RegExp regex = RegExp(r'^(?=.*?[0-9]).{0,}$');

    if (value.isEmpty) {
      return "Please enter fax number";
    } else if (!regex.hasMatch(value)) {
      return "Please enter valid fax number";
    }
    return null;
  }

  String? driverNameField(String value) {
    if (value.isEmpty) {
      return "Please enter driver name";
    }
    return null;
  }
}
