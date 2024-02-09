
import 'package:flutter/cupertino.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';

import 'form_field_validation.dart';

class AuthFormValidation {
  FormFieldValidation formFieldValidation = FormFieldValidation();

  String? formValidation(String value, String field , BuildContext context) {
    switch (field) {

      case AppStrings.emailValString:
        return formFieldValidation.emailField(value,context);

      // case "phoneNum":
      //   return formFieldValidation.phoneNumField(value);
      case AppStrings.mobileValString:
        return formFieldValidation.mobileField(value,context);

      case AppStrings.businessNameValString:
        return formFieldValidation.businessNameField(value,context);

      case AppStrings.hpValString:
        return formFieldValidation.hpField(value,context);

      case AppStrings.ownerNameValString:
        return formFieldValidation.ownerNameField(value,context);

      case AppStrings.idValString:
        return formFieldValidation.idField(value,context);

      case AppStrings.contactNameValString:
        return formFieldValidation.contactNameField(value,context);

      case AppStrings.addressValString:
        return formFieldValidation.addressNameField(value,context);

      case AppStrings.emailValString:
        return formFieldValidation.emailField(value ,context);

      case AppStrings.faxValString:
        return formFieldValidation.faxField(value,context);

      case AppStrings.cityValString:
        return formFieldValidation.cityNameField(value,context);
    }
    return null;
  }
}
