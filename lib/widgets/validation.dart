import 'dart:developer';

import '../config.dart';

class Validation {
  RegExp digitRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  RegExp regex = RegExp("^([0-9]{4}|[0-9]{6})");


  // phone validation
  phoneValidation(phone) {

    if (phone.isEmpty) {
      return appFonts.pleaseEnterValue.tr;
    }
    return null;
  }

  // Otp Validation
  otpValidation (value) {
    log("dd : $value");
    if (value!.isEmpty) {
      return ("Enter otp ");
    }else
    if (!regex.hasMatch(value)) {
      return ("Enter valid otp");
    }else {
      return null;
    }

  }

  // Email Validation
  emailValidation(email) {
    if (email.isEmpty) {
      return appFonts.pleaseEnterEmail.tr;
    } else if (!digitRegex.hasMatch(email)) {
      return appFonts.pleaseEnterValid.tr;
    }
    return null;
  }

  // name validation
  nameValidation(name) {
    if (name.isEmpty) {
      return appFonts.pleaseEnterValue.tr;
    }

    return null;
  }

}
