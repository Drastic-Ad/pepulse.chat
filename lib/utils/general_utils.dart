
import 'dart:io';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../config.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypted;

import '../main.dart';


String klu = "dHJ1ZQ==";


typedef StringCallbacks = void Function(String);
typedef VoidCallBack = void Function();
typedef DoubleCallBack = void Function(double, double);
typedef VoidCallBackWithFuture = Future<void> Function();
typedef StringsCallBacks = void Function(String emoji, String messageId);
typedef StringWithReturnWidget = Widget Function(String separator);
typedef DragUpdateDetailsCallback = void Function(DragUpdateDetails);

const String heart = "❤";
const String faceWithTears = "😂";
const String disappointedFace = "😥";
const String angryFace = "😡";
const String astonishedFace = "😲";
const String thumbsUp = "👍";

decryptMessage(content) {
  String decryptedText = decrypt(content);
  return decryptedText;
}

String decrypt(encryptedData) {
  final key = encrypted.Key.fromUtf8(encryptedKey);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(encryptedKey.substring(0, 16));
  return encrypter.decrypt(Encrypted.fromBase64(encryptedData), iv: initVector);
}

Encrypted encryptFun(String plainText) {
  final key = encrypted.Key.fromUtf8(encryptedKey);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(encryptedKey.substring(0, 16));
  Encrypted encryptedData = encrypter.encrypt(plainText, iv: initVector);
  return encryptedData;
}


anikanisani(){
  klu = kDebugMode ? "dHJ1ZQ==" : "ZmFsc2U=";
  return klu;
}

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) {
    return '0 B';
  }
  const List<String> suffixes = <String>[
    'B',
    'KB',
    'MB',
    'GB',
    'TB',
    'PB',
    'EB',
    'ZB',
  ];
  final int i = (math.log(bytes / 100) / math.log(1024)).floor();
  return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

String name = "";
final fetch = Provider.of<FetchContactController>(Get.context!, listen: false);
List<String> myArray =
    fetch.contactList!.entries.toList().map((e) => e.value.toString()).toList();
List<String> myArray1 =
    fetch.contactList!.entries.toList().map((e) => e.key.toString()).toList();

String getVideoSize({required File file}) => formatBytes(file.lengthSync(), 2);

int getUnseenMessagesNumber(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> items) {
  int counter = 0;
  items.asMap().entries.forEach((element) {
    if (!element.value.data()["isSeen"]) {
      counter++;
    }
  });
  return counter;
}

//phone number split
String phoneNumberExtension(phoneNumber) {
  String phone = phoneNumber;
  if (phone.length > 10) {
    if (phone.contains(" ")) {
      phone = phone.replaceAll(" ", "");
    }
    if (phone.contains(" ")) {
      phone = phone.replaceAll("  ", "");
    }
  }
  return phone;
}

List phoneList({
  String? phone,
  String? dialCode,
}) {
  List list = [
    '+${dialCode!.substring(1)}$phone',
    '+${dialCode.substring(1)}-$phone',
    '${dialCode.substring(1)}-$phone',
    '${dialCode.substring(1)}$phone',
    '0${dialCode.substring(1)}$phone',
    '0$phone',
    '$phone',
    '+$phone',
    '+${dialCode.substring(1)}--$phone',
    '00$phone',
    '00${dialCode.substring(1)}$phone',
    '+${dialCode.substring(1)}-0$phone',
    '+${dialCode.substring(1)}0$phone',
    '${dialCode.substring(1)}0$phone',
  ];
  return list;
}

phoneNumberVariantsList({
  String? phone,
  String countryCode = "",
}) {
  bool isNumberContains = false;
  List list = [];
  if (countryCode != "") {
    list = [
      '+${countryCode.substring(1)}$phone',
      '+${countryCode.substring(1)}-$phone',
      '${countryCode.substring(1)}-$phone',
      '${countryCode.substring(1)}$phone',
      '0${countryCode.substring(1)}$phone',
      '0$phone',
      '$phone',
      '+$phone',
      '+${countryCode.substring(1)}--$phone',
      '00$phone',
      '00${countryCode.substring(1)}$phone',
      '+${countryCode.substring(1)}-0$phone',
      '+${countryCode.substring(1)}0$phone',
      '${countryCode.substring(1)}0$phone',
    ];
  } else {
    list = [
      '+$phone',
      '+-$phone',
      '-$phone',
      '$phone',
      '0$phone',
      '$phone',
      '+--$phone',
      '00$phone',
      '+-0$phone',
      '+0$phone',
    ];
  }

  isNumberContains = list.where((element) => element == phone).isEmpty;

  return isNumberContains;
}

int getGroupUnseenMessagesNumber(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> items) {
  int counter = 0;
  items.asMap().entries.forEach((element) {
    if (element.value.data().containsKey("seenMessageList")) {
      if (!element.value
          .data()["seenMessageList"]
          .contains(appCtrl.user["id"])) {
        counter++;
      }
    }
  });
  return counter;
}

Future<List<Contact>> getAllContacts() async {
  var contacts = (await FastContacts.getAllContacts());
  return contacts;
}

getDate(date) {
  DateTime now = DateTime.now();
  String when;
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
  if (dateTime.day == now.day) {
    when = 'Today';
  } else if (dateTime.day == now.subtract(const Duration(days: 1)).day) {
    when = 'Yesterday';
  } else {
    when = "${DateFormat.MMMd().format(dateTime)}-other";
  }
  return when;
}

getWhen(date) {
  DateTime now = DateTime.now();
  String when;
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
  if (dateTime.day == now.day) {
    when = 'Today';
  } else if (dateTime.day == now.subtract(const Duration(days: 1)).day) {
    when = 'Yesterday';
  } else {
    when = "${DateFormat.MMMd().format(dateTime)}-other";
  }
  return when;
}

linkCondition(document) {
  bool contentType = (decryptMessage(document!.content).contains("youtube") ||
      decryptMessage(document!.content).contains("youtu.be") ||
      decryptMessage(document!.content).contains("instagram.com") ||
      decryptMessage(document!.content).contains("fb.watch"));

  return contentType;
}

String messageTypeCondition(MessageType type, content) {
  if (type == MessageType.image || type == MessageType.imageArray) {
    return "\u{1F4F8} Photo";
  } else if (type == MessageType.video) {
    return "\u{1F3A5} Video";
  } else if (type == MessageType.audio) {
    return "\u{1F3A4} Audio";
  } else if (type == MessageType.doc) {
    return "\u{1f4c4} Document";
  } else if (type == MessageType.location) {
    return "\u{1F4CD} Location";
  } else if (type == MessageType.link) {
    return "\u{1F517} Link";
  } else if (type == MessageType.contact) {
    return "\u{1F464} ${content.toString().split("-BREAK-")[0]}";
  } else if (type == MessageType.gif) {
    return "\u{1F47E} GIF";
  } else {
    return content;
  }
}

String groupMessageTypeCondition(MessageType type, content) {
  if (type == MessageType.image || type == MessageType.imageArray) {
    return "${appCtrl.user["name"]} \u{1F4F8} Photo";
  } else if (type == MessageType.video) {
    return "${appCtrl.user["name"]} \u{1F3A5} Video";
  } else if (type == MessageType.audio) {
    return "${appCtrl.user["name"]} \u{1F3A4} Audio";
  } else if (type == MessageType.doc) {
    return "${appCtrl.user["name"]} \u{1f4c4} Document";
  } else if (type == MessageType.location) {
    return "${appCtrl.user["name"]} \u{1F4CD} Location";
  } else if (type == MessageType.link) {
    return "${appCtrl.user["name"]} \u{1F517} Link";
  } else if (type == MessageType.contact) {
    return "${appCtrl.user["name"]} \u{1F464} ${content.toString().split("-BREAK-")[0]}";
  } else if (type == MessageType.gif) {
    return "${appCtrl.user["name"]} \u{1F47E} GIF";
  } else {
    return content;
  }
}

int calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}

contactName(val, {isSearch = false}) {
  name ="";
  int registerIndex = 0;
  if (isSearch) {
    registerIndex = myArray.indexWhere(
        (element) => element.removeAllWhitespace.toLowerCase().contains(val));
  } else {
    registerIndex = myArray1.indexWhere(
        (element) => element.removeAllWhitespace.toLowerCase().contains(val));
  }
  if (registerIndex >= 0) {
    MapEntry user = fetch.contactList!.entries.elementAt(registerIndex);
    name = user.value;
  }else{
    return name;
  }

  return name;
}
