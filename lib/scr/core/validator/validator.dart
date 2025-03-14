// let's custom the Regex flexible with your check.
// There is four type Regex that I check.

import 'package:b2b/scr/core/language/app_translate.dart';

abstract class Validator {
  Validator({this.maxLength, this.minLength, this.regexInvalidMessage});

  int? maxLength;
  int? minLength;
  String? regexInvalidMessage;

  String? checkValidate(String textInput, RegExp regExp) {
    if (maxLength != null && textInput.length > maxLength!) {
      return AppTranslate.i18n.titleOutOfCharacterStr.localized;
    } else if (minLength != null && textInput.length < minLength!) {
      return AppTranslate.i18n.titleNotLengthOfCharacterStr.localized;
    } else if (!regExp.hasMatch(textInput)) {
      return regexInvalidMessage ?? 'invalid';
    }
    return null;
  }

  String? validate(String textInput);
}

// Validator for Name or UserName
class UserNameInputValidator extends Validator {
  UserNameInputValidator({int? maxLength, int? minLength})
      : super(maxLength: maxLength, minLength: minLength);

  final RegExp regexUserName = RegExp('^[a-zA-Z]{1}[a-zA-Z0-9 ]');

  @override
  String? validate(String textInput) {
    return super.checkValidate(textInput, regexUserName);
  }
}

// Validator for Password
class PasswordInputValidator extends Validator {
  PasswordInputValidator(
      {int? maxLength, int? minLength, String? regexInvalidMessage})
      : super(
            maxLength: maxLength,
            minLength: minLength,
            regexInvalidMessage: regexInvalidMessage);

  //Minimum eight characters, at least one uppercase letter, one lowercase, one number and one special character:
  final RegExp regexPassword =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[@#\$%^&+=]).{8,}$');

  @override
  String? validate(String textInput) {
    int? _minLength = minLength;
    int? _maxLength = maxLength;

    if (_minLength != null && textInput.length < _minLength) {
      return AppTranslate.i18n.titleNotLengthOfCharacterStr.localized;
    } else if (_maxLength != null && textInput.length > _maxLength) {
      return AppTranslate.i18n.titleOutOfCharacterStr.localized;
    } else if (testSequences(textInput) == false || textInput.contains(' ')) {
      return regexInvalidMessage;
    } else {
      return super.checkValidate(textInput, regexPassword);
    }
  }

  bool testSequences(String input) {
    final String lowerCase = 'qwertyuiopasdfghjklzxcvbnm';
    final String upperCase = lowerCase.toUpperCase();
    final String number = '1234567890';

    for (int i = 0; i <= input.length - 4; i++) {
      String testString = input.substring(i, i + 4);
      if (lowerCase.contains(testString) ||
          upperCase.contains(testString) ||
          number.contains(testString)) {
        return false;
      }
    }

    return true;
  }
}

// Validator for number (may it's phone number)
class NumberInputValidator extends Validator {
  NumberInputValidator({int? maxLength, int? minLength})
      : super(maxLength: maxLength, minLength: minLength);

  final RegExp regexPhoneNumber = RegExp('^[0-9]*\$');

  @override
  String? validate(String textInput) {
    final validate = super.checkValidate(textInput, regexPhoneNumber);
    if (validate != null && validate == 'invalid') {
      return AppTranslate.i18n.wrongFormatInputStr.localized;
    } else {
      return null;
    }
  }
}

// Validator for Email
class EmailInputValidator extends Validator {
  EmailInputValidator({int? maxLength, int? minLength})
      : super(maxLength: maxLength, minLength: minLength);

  final RegExp regexEmail = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  @override
  String? validate(String textInput) {
    final validate = super.checkValidate(textInput, regexEmail);
    if (validate != null && validate == 'invalid') {
      if (!textInput.contains('@')) {
        return AppTranslate.i18n.titleEmailFormatStr.localized;
      }
    } else {
      return validate;
    }
    return null;
  }
}
