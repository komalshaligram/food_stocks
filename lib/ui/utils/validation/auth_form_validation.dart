
import 'package:flutter/cupertino.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';

import 'form_field_validation.dart';

class AuthFormValidation {
  FormFieldValidation formFieldValidation = FormFieldValidation();

  String? formValidation(String value, String field , BuildContext context) {
    switch (field) {

      case AppStrings.emailValString:
        return formFieldValidation.emailField(value,context);

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

      case AppStrings.faxValString:
        return formFieldValidation.faxField(value,context);

      case AppStrings.guaranteeNameString:
        return formFieldValidation.guaranteeNameField(value,context);

      case AppStrings.branchValString:
        return formFieldValidation.branchNumberField(value,context);

      case AppStrings.accountValString:
        return formFieldValidation.accountNumberField(value,context);

      case AppStrings.streetNameValString:
        return formFieldValidation.streetNameField(value,context);

      case AppStrings.streetNumberValString:
        return formFieldValidation.streetNumberField(value,context);

      case AppStrings.zipValString:
        return formFieldValidation.zipField(value,context);

      case AppStrings.surfaceValString:
        return formFieldValidation.surfaceField(value,context);

      case AppStrings.subUserValString:
        return formFieldValidation.subUserNameField(value,context);

      case AppStrings.creditCardNumberString:
        return formFieldValidation.creditCardNumberField(value,context);

      case AppStrings.creditCardValidityString:
        return formFieldValidation.creditCardValidityField(value,context);

    }
    return null;
  }
}
