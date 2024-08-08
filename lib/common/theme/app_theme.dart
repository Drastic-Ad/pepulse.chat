import 'package:flutter/material.dart';

enum ThemeType {
  light,
  dark,
}

class AppTheme {
  static ThemeType defaultTheme = ThemeType.light;

  //Theme Colors
  bool isDark;
  Color txt;
  Color primary;
  Color primaryLight;
  Color primaryLight1;
  Color primaryLight2;
  Color primaryLightBorder;
  Color primaryShadow;
  Color secondary;
  Color accentTxt;
  Color screenBG;
  Color surface;
  Color error;
  Color main;
  Color darkText;
  Color lightText;
  Color icon;
  Color clickableText;
  Color boxBg;
  Color mainBg;
  Color white;
  Color linerGradiant;
  Color indicator;
  Color mainLight;
  Color dash;
  Color divider;
  Color trans;
  Color black;
  Color yellow;
  Color sameWhite;
  Color sameBlack;
  Color borderColor;
  Color toggleSwitch;
  Color trackActive;
  Color radialGradient;
  Color bg;
  Color textField;
  Color greyText;
  Color redColor;
  Color yellowColor;
  Color online;
  Color tick;

  /// Default constructor
  AppTheme({
    required this.isDark,
    required this.txt,
    required this.primary,
    required this.primaryLight,
    required this.primaryLight1,
    required this.primaryLight2,
    required this.primaryLightBorder,
    required this.primaryShadow,
    required this.secondary,
    required this.accentTxt,
    required this.screenBG,
    required this.surface,
    required this.error,
    required this.main,
    required this.darkText,
    required this.lightText,
    required this.icon,
    required this.clickableText,
    required this.boxBg,
    required this.mainBg,
    required this.white,
    required this.linerGradiant,
    required this.indicator,
    required this.mainLight,
    required this.dash,
    required this.divider,
    required this.black,
    required this.trans,
    required this.yellow,
    required this.sameWhite,
    required this.sameBlack,
    required this.borderColor,
    required this.toggleSwitch,
    required this.trackActive,
    required this.radialGradient,
    required this.bg,
    required this.textField,
    required this.greyText,
    required this.redColor,
    required this.yellowColor,
    required this.online,
    required this.tick
  });

  /// fromType factory constructor
  factory AppTheme.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppTheme(
          isDark: false,
          txt: const Color(0xFF323444),
          primary: const Color(0xff01AA85),
          darkText: const Color(0xff2C2C2C),
          greyText: const Color(0xff7F8384),
          screenBG: const Color(0xffFCFCFC),
          white: Colors.white,
          borderColor: const Color(0xffF2F3F3),
          online: const Color(0xff4DD68C),
          tick: const Color(0xff80D4C2),

          primaryLight: const Color.fromRGBO(53, 193, 255, 0.1),
          primaryLight1: const Color.fromRGBO(53, 193, 255, 0.2),
          primaryLight2: const Color(0xFFD7F3FF),
          primaryLightBorder: const Color.fromRGBO(53, 193, 255, 0.4),
          primaryShadow: const Color.fromRGBO(53, 193, 255, 0.06),
          secondary: const Color(0xFF6EBAE7),
          accentTxt: const Color(0xFF001928),
         
          surface: Colors.white,
          error: const Color(0xFFd32f2f),
          icon: const Color(0xff3E9B0E),
          main: const Color(0xffFF8D2F),
          lightText: const Color(0xffAFB0B6),
          clickableText: const Color(0xff4D66FF),
          mainBg: const Color(0x00fff0e3),
          boxBg: Colors.white,

          linerGradiant: const Color(0xff848485),
          indicator: const Color(0xffDFDFDF),
          mainLight: const Color(0xffFFF0E3),
          dash: const Color(0xffD6D6D6),
          divider: const Color(0xffEBEBEB),
          trans: Colors.transparent,
          black: Colors.black,
          yellow: const Color(0xffC38D25),
          sameWhite: Colors.white,
          sameBlack: Colors.black,

          toggleSwitch: const Color(0xffF5F5F5),
          trackActive: const Color(0xffFFF0E3),
          radialGradient: const Color(0xff179EEA),
          bg: const Color(0xff4D4F5D),
          textField: const Color(0xffF5F5F6),

          redColor: const Color(0XFFFE3D3D),
          yellowColor: const Color(0XFFFFC700),
        );

      case ThemeType.dark:
        return AppTheme(
          isDark: true,
          txt: Colors.white,
          primary: const Color(0xff01AA85),
          darkText: const Color(0xfff5f5f5),
          greyText: const Color(0xff7F8384),
          screenBG: const Color(0xff262424),
          white: const Color(0xff333232),
          borderColor: const Color(0xff262424),
          online: const Color(0xff4DD68C),
          tick: const Color(0xff80D4C2),

          primaryLight: const Color.fromRGBO(53, 193, 255, 0.1),
          primaryLight1: const Color.fromRGBO(53, 193, 255, 0.2),
          primaryLight2: const Color(0xFFD7F3FF),
          primaryLightBorder: const Color.fromRGBO(53, 193, 255, 0.4),
          primaryShadow: const Color(0xFF323444),
          secondary: const Color(0xFF6EBAE7),
          accentTxt: const Color(0xFF001928),

          surface: const Color(0xFF4D4F5D),
          // add

          error: const Color(0xFFd32f2f),
          icon: const Color(0xff3E9B0E),
          main: const Color(0xffFF8D2F),

          lightText: const Color(0xffAFB0B6),
          clickableText: const Color(0xff4D66FF),
          mainBg: const Color(0x00fff0e3),
          boxBg: const Color(0xff3E404F),

          linerGradiant: const Color(0xff848485),
          indicator: const Color(0xffDFDFDF),
          mainLight: const Color(0xffFFF0E3),
          dash: const Color(0xffD6D6D6),
          divider: const Color(0xffEBEBEB),
          trans: Colors.transparent,
          black: Colors.white,
          yellow: const Color(0xffC38D25),
          sameWhite: Colors.white,
          sameBlack: Colors.black,

          toggleSwitch: const Color(0xff2A2A2A),
          trackActive: const Color(0xff4E3B2B),
          radialGradient: const Color(0xff179EEA),
          bg: const Color(0xff4D4F5D),
          textField: const Color(0xff4D4F5D),

          redColor: const Color(0XFFFE3D3D),
          yellowColor: const Color(0XFFFFC700),
        );
    }
  }

  ThemeData get themeData {
    var t = ThemeData.from(
      textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        secondary: secondary,
        background: screenBG,
        surface: surface,
        onBackground: txt,
        onSurface: txt,
        onError: txt,
        onPrimary: accentTxt,
        onSecondary: accentTxt,
        error: error,primaryContainer: white,surfaceTint: white
      ),
    );

    return t.copyWith(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Colors.transparent, cursorColor: primary),
      buttonTheme: ButtonThemeData(buttonColor: primary),
      highlightColor: primary,
    );
  }
}
