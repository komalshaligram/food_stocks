import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class FormFieldValidation {

  String? emailField(String value,BuildContext context) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value.isEmpty) {
      return '${AppLocalizations.of(context)!.please_enter_email}';
    } else {
      if (!regex.hasMatch(value)) {
        return '${AppLocalizations.of(context)!.please_enter_valid_email}';
      } else {
        return null;
      }
    }
  }


  String? mobileField(String value,BuildContext context) {
    RegExp regex = RegExp(r"^(?=.*?[a-zA-Z.!#$%&'*+-/=?^_`{|}~]).*$");
    if (value.trim().isEmpty) {
      return '${AppLocalizations.of(context)!.please_enter_valid_phone_number}';
    } else if (value.length <= 10) {
      if (regex.hasMatch(value)) {
        return "${AppLocalizations.of(context)!.please_enter_valid_phone_number}";
      }
      else if(value.length < 10){
        return "${AppLocalizations.of(context)!.phone_number_must_be_10digit}";
      }
      else{
        return null;
      }
    } else if (value.length > 10) {
      return "${AppLocalizations.of(context)!.phone_number_must_be_10digit}";
    }
    else {
      return null;
    }
  }

  String? businessNameField(String value,BuildContext context) {
    RegExp regex = RegExp(r"^(?=.*?[0-9.!#$%&'*₹+-/=?^_`{|}~]).*$");
    RegExp regex1 = RegExp(r"^(?=.*?[a-zA-zא-ת]).*$");
    if (value.isEmpty) {
      return '${AppLocalizations.of(context)!.please_enter_your_business_name}';
    } else if (regex.hasMatch(value)) {
      return '${AppLocalizations.of(context)!.please_enter_alphabets_only}';
    } else if (!regex1.hasMatch(value)) {
      return '${AppLocalizations.of(context)!.please_enter_valid_business_name}';
    }
    return null;
  }

  String? hpField(String value,BuildContext context) {
    RegExp regex = RegExp(r'^(?=.*?[0-9]).{0,}$');
    if (value.isEmpty) {
      return "${AppLocalizations.of(context)!.please_enter_business_id}";
    } else if (!regex.hasMatch(value)) {
      return "${AppLocalizations.of(context)!.please_enter_valid_business_id}";
    }
    return null;
  }

  String? ownerNameField(String value,BuildContext context) {
    RegExp regex = RegExp(r"^(?=.*?[0-9.!#$%&'*+-/=?^_`{|}~]).*$");
    RegExp regex1 = RegExp(r"^(?=.*?[a-zA-zא-ת]).*$");
    if (value.isEmpty) {
      return '${AppLocalizations.of(context)!.please_enter_owner_name}';
    } else if (regex.hasMatch(value)) {
      return '${AppLocalizations.of(context)!.please_enter_alphabets_only}';
    } else if (!regex1.hasMatch(value)) {
      return '${AppLocalizations.of(context)!.enter_valid_owner_name}';
    }
    return null;
  }

  String? idField(String value,BuildContext context) {
    RegExp regex = RegExp(r'^(?=.*?[0-9]).{0,}$');
    if (value.isEmpty) {
      return "${AppLocalizations.of(context)!.please_enter_israel_id}";
    } else if (!regex.hasMatch(value)) {
      return "${AppLocalizations.of(context)!.please_enter_valid_israel_id}";
    }
    return null;
  }

  String? contactNameField(String value,BuildContext context) {
    RegExp regex = RegExp(r"^(?=.*?[0-9.!#$%&'*₹+-/=?^_`{|}~]).*$");
    RegExp regex1 = RegExp(r"^(?=.*?[a-zA-zא-ת]).*$");
    if (value.isEmpty) {
      return "${AppLocalizations.of(context)!.please_enter_contact_name}";
    } else if (regex.hasMatch(value)) {
      return '${AppLocalizations.of(context)!.please_enter_alphabets_only}';
    } else if (!regex1.hasMatch(value)) {
      return '${AppLocalizations.of(context)!.enter_valid_contact_name}';
    }
    return null;
  }

  String? addressNameField(String value,BuildContext context) {
    RegExp regex = RegExp(r"^(?=.*?[!#$%&'*@<>:)(;₹+=?^_`{|}~]).*$");
    RegExp regex1 = RegExp(r"^(?=.*?[a-zA-zא-ת]).*$");
    if (value.isEmpty) {
      return "${AppLocalizations.of(context)!.please_enter_address}";
    } else if (regex.hasMatch(value)) {
      return "${AppLocalizations.of(context)!.enter_valid_address}";
    } else if (!regex1.hasMatch(value)) {
      return '${AppLocalizations.of(context)!.enter_valid_address}';
    }
    return null;
  }

  String? faxField(String value,BuildContext context) {
    // RegExp regex = RegExp(r'^(?=.*?[0-9]).{0,}$');
    if (value.trim().isEmpty) {
      return null;
    } /*else if (value.length < 15 *//*!regex.hasMatch(value)*//*) {
      return "${AppLocalizations.of(context)!.please_enter_valid_fax_number}";
    }*/
   /* else if(value.length > 15){
      return "${AppLocalizations.of(context)!.please_enter_valid_fax_number}";
    }*/
    return null;
  }

  String? driverNameField(String value,BuildContext context) {
    RegExp regex = RegExp(r"^(?=.*?[0-9.!#$%&'*+-/=?^_`{|}~]).*$");
    RegExp regex1 = RegExp(r"^(?=.*?[a-zA-zא-ת]).*$");
    if (value.isEmpty) {
      return 'Please enter driver name';
    } else if (regex.hasMatch(value)) {
      return '${AppLocalizations.of(context)!.please_enter_alphabets_only}';
    } else if (!regex1.hasMatch(value)) {
      return 'Please enter valid driver name';
    }
    return null;
  }

  String? cityNameField(String value,BuildContext context) {
    if (value.isEmpty) {
      return '${AppLocalizations.of(context)!.please_enter_owner_name}';
    }
    return null;
  }
}