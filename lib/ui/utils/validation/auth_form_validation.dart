import 'package:food_stock/ui/utils/themes/app_strings.dart';

import 'form_field_validation.dart';

class AuthFormValidation {
  FormFieldValidation formFieldValidation = FormFieldValidation();

  String? formValidation(String value, String field) {
    switch (field) {

      case AppStrings.emailValString:
        return formFieldValidation.emailField(value);

      // case "phoneNum":
      //   return formFieldValidation.phoneNumField(value);
      case AppStrings.mobileValString:
        return formFieldValidation.mobileField(value);

      case AppStrings.generalValString:
        return formFieldValidation.simpleTextField(value);

      case "number":
        return formFieldValidation.simpleNumberField(value.toString());

      case AppStrings.businessNameValString:
        return formFieldValidation.businessNameField(value);

      case AppStrings.hpValString:
        return formFieldValidation.hpField(value);

      case AppStrings.ownerNameValString:
        return formFieldValidation.ownerNameField(value);

      case AppStrings.idValString:
        return formFieldValidation.idField(value);

      case AppStrings.contactNameValString:
        return formFieldValidation.contactNameField(value);

      case AppStrings.addressValString:
        return formFieldValidation.addressNameField(value);

      case AppStrings.emailValString:
        return formFieldValidation.emailField(value);

      case AppStrings.faxValString:
        return formFieldValidation.faxField(value);

      case AppStrings.driverNameString:
        return formFieldValidation.driverNameField(value);

    }
    return null;
  }
}
