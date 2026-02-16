import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FormFieldValidation {
  String? emailField(String value, BuildContext context) {
    RegExp regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.please_enter_valid_email;
    } else {
      return null;
    }
  }

  String? mobileField(String value, BuildContext context) {
    RegExp regex = RegExp(r"^(?=.*?[a-zA-Z.!#$%&'*+-/=?^_`{|}~]).*$");
    if (value.trim().isEmpty) {
      return AppLocalizations.of(context)!.please_enter_valid_phone_number;
    } else if (value.length <= 10) {
      if (regex.hasMatch(value)) {
        return AppLocalizations.of(context)!.please_enter_valid_phone_number;
      } else if (value.length < 10) {
        return AppLocalizations.of(context)!.phone_number_must_be_10digit;
      } else {
        return null;
      }
    } else if (value.length > 10) {
      return AppLocalizations.of(context)!.phone_number_must_be_10digit;
    } else {
      return null;
    }
  }

  String? agentCodeField(String agentCode, BuildContext context) {
    if (agentCode.length != 6) {
      return AppLocalizations.of(context)!.agent_code_length_error;
    }
    return null;
  }

  String? businessNameField(String value, BuildContext context) {
    RegExp regex = RegExp(r"^(?=.*?[0-9.!#$%&'*₹+-/=?^_`{|}~]).*$");
    RegExp regex1 = RegExp(r"^(?=.*?[a-zA-zא-ת]).*$");
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_your_business_name;
    } else if (regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.please_enter_alphabets_only;
    } else if (!regex1.hasMatch(value)) {
      return AppLocalizations.of(context)!.please_enter_valid_business_name;
    }
    return null;
  }

  String? hpField(String value, BuildContext context) {
    RegExp regex = RegExp(r'^(?=.*?[0-9]).{0,}$');
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_business_id;
    } else if (!regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.please_enter_valid_business_id;
    }
    return null;
  }

  String? ownerNameField(String value, BuildContext context) {
    RegExp regex = RegExp(r"^(?=.*?[0-9.!#$%&'*+-/=?^_`{|}~]).*$");
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_owner_name;
    } else if (regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.please_enter_alphabets_only;
    } else if (!value.contains(' ')) {
      return AppLocalizations.of(context)!.enter_valid_owner_name;
    }
    return null;
  }

  String? ownerFirstNameField(String value, BuildContext context) {
    RegExp regex = RegExp(r"^(?=.*?[0-9.!#$%&'*+-/=?^_`{|}~]).*$");
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_owner_name;
    } else if (regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.please_enter_alphabets_only;
    }
    return null;
  }

  String? owner2NameField(String value, BuildContext context) {
    RegExp regex = RegExp(r"^(?=.*?[0-9.!#$%&'*+-/=?^_`{|}~]).*$");
    if (regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.please_enter_alphabets_only;
    } else if (!value.contains(' ')) {
      return AppLocalizations.of(context)!.enter_valid_owner_name;
    }
    return null;
  }

  String? idField(String value, BuildContext context) {
    RegExp regex = RegExp(r'^(?=.*?[0-9]).{0,}$');
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_israel_id;
    } else if (!regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.please_enter_valid_israel_id;
    }
    return null;
  }

  String? contactNameField(String value, BuildContext context) {
    RegExp regex = RegExp(r"^(?=.*?[0-9.!#$%&'*₹+-/=?^_`{|}~]).*$");
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_contact_name;
    } else if (regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.please_enter_alphabets_only;
    } else if (!value.contains(' ')) {
      return AppLocalizations.of(context)!.enter_valid_contact_name;
    }
    return null;
  }

  String? addressNameField(String value, BuildContext context) {
    RegExp regex = RegExp(r"^(?=.*?[!#$%&'*@<>:)(;₹+=?^_`{|}~]).*$");
    RegExp regex1 = RegExp(r"^(?=.*?[a-zA-zא-ת]).*$");
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_address;
    } else if (regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.enter_valid_address;
    } else if (!regex1.hasMatch(value)) {
      return AppLocalizations.of(context)!.enter_valid_address;
    }
    return null;
  }

  String? guaranteeNameField(String value, BuildContext context) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_guarantee1_name;
    } else if (!value.contains(' ')) {
      return AppLocalizations.of(context)!.please_enter_valid_guarantee_name1;
    }
    return null;
  }

  String? guaranteeName2Field(String value, BuildContext context) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_guarantee2_name;
    } else if (!value.contains(' ')) {
      return AppLocalizations.of(context)!.please_enter_valid_guarantee_name2;
    }
    return null;
  }

  String? branchNumberField(String value, BuildContext context) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_branch_number;
    }

    return null;
  }

  String? accountNumberField(String value, BuildContext context) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_account_number;
    }

    return null;
  }

  String? streetNameField(String value, BuildContext context) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.enter_street_name;
    }
    return null;
  }

  String? streetNumberField(String value, BuildContext context) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.enter_street_number;
    }
    return null;
  }

  String? zipField(String value, BuildContext context) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.enter_zip;
    }
    return null;
  }

  String? surfaceField(String value, BuildContext context) {
    RegExp regex = RegExp(r'^(?=.*?[0-9]).{0,}$');
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_surfaces;
    } else if (!regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.please_enter_surfaces;
    }

    return null;
  }

  String? driverNameField(String value, BuildContext context) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_driverName;
    }
    return null;
  }

  String? subUserNameField(String value, BuildContext context) {
    RegExp regex = RegExp(r"^(?=.*?[0-9.!#$%&'*+-/=?^_`{|}~]).*$");
    RegExp regex1 = RegExp(r"^(?=.*?[a-zA-zא-ת]).*$");
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_sub_user;
    } else if (regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.please_enter_alphabets_only;
    } else if (!regex1.hasMatch(value)) {
      return AppLocalizations.of(context)!.enter_valid_owner_name;
    }
    return null;
  }

  String? creditCardNumberField(String value, BuildContext context) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.enter_credit_card_number;
    }
    return null;
  }

  String? creditCardValidityField(String value, BuildContext context) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.enter_credit_card_validity;
    } else if (int.parse(value) < int.parse(DateTime.now().year.toString().substring(2, 4))) {
      return AppLocalizations.of(context)!.enter_valid_year;
    }
    return null;
  }
}
