import 'form_field_validation.dart';

class AuthFormValidation {
  FormFieldValidation formFieldValidation = FormFieldValidation();

  String? formValidation(String value, String field) {
    switch (field) {

      case "email":
        return formFieldValidation.emailField(value);
    // break;

      // case "password":
      //   return formFieldValidation.validatePassword(value);
    // break;

      case "phoneNum":
        return formFieldValidation.phoneNumField(value);
    // break;

      case "text":
        return formFieldValidation.simpleTextField(value);
    // break;
      case "number":
        return formFieldValidation.simpleNumberField(value.toString());

    }
    return null;
  }
}
