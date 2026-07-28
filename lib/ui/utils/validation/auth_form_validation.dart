import 'package:flutter/cupertino.dart';
import '../constants/app_strings.dart';
import 'form_field_validation.dart';

class AuthFormValidation {
  FormFieldValidation formFieldValidation = FormFieldValidation();

  String? formValidation(String value, String field, int availableQtyVal, BuildContext context, {int? availableQty}) {
    switch (field) {
      case AppStrings.emailValString:
        return formFieldValidation.emailField(value, context);

      case AppStrings.mobileValString:
        return formFieldValidation.mobileField(value, context);

      case AppStrings.agentCodeString:
        return formFieldValidation.agentCodeField(value, context);

      case AppStrings.businessNameValString:
        return formFieldValidation.businessNameField(value, context);

      case AppStrings.hpValString:
        return formFieldValidation.hpField(value, context);

      case AppStrings.ownerNameValString:
        return formFieldValidation.ownerNameField(value, context);

      case AppStrings.ownerName2ValString:
        return formFieldValidation.owner2NameField(value, context);

      case AppStrings.ownerFirstNameValString:
        return formFieldValidation.ownerFirstNameField(value, context);

      case AppStrings.idValString:
        return formFieldValidation.idField(value, context);

      case AppStrings.contactNameValString:
        return formFieldValidation.contactNameField(value, context);

      case AppStrings.contactPersonNameValString:
        return formFieldValidation.contactPersonNameField(value, context);

      case AppStrings.addressValString:
        return formFieldValidation.addressNameField(value, context);

      case AppStrings.guaranteeName2String:
        return formFieldValidation.guaranteeName2Field(value, context);
      case AppStrings.guaranteeNameString:
        return formFieldValidation.guaranteeNameField(value, context);

      case AppStrings.branchValString:
        return formFieldValidation.branchNumberField(value, context);

      case AppStrings.accountValString:
        return formFieldValidation.accountNumberField(value, context);

      case AppStrings.streetNameValString:
        return formFieldValidation.streetNameField(value, context);

      case AppStrings.streetNumberValString:
        return formFieldValidation.streetNumberField(value, context);

      case AppStrings.zipValString:
        return formFieldValidation.zipField(value, context);

      case AppStrings.surfaceValString:
        return formFieldValidation.surfaceField(value, availableQtyVal, context);

      case AppStrings.driverNameString:
        return formFieldValidation.driverNameField(value, context);

      case AppStrings.subUserValString:
        return formFieldValidation.subUserNameField(value, context);

      case AppStrings.creditCardNumberString:
        return formFieldValidation.creditCardNumberField(value, context);

      case AppStrings.creditCardValidityString:
        return formFieldValidation.creditCardValidityField(value, context);
    }
    return null;
  }
}
