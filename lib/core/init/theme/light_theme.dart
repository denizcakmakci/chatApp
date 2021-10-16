import 'package:flutter/material.dart';

final ThemeData _lightTheme = ThemeData(
  fontFamily: 'Nunito',
  brightness: Brightness.light,
  primaryColor: const Color(0xffFFD7D3),
  primaryColorBrightness: Brightness.dark,
  primaryColorLight: const Color(0xff353535),
  primaryColorDark: const Color(0xff13074A),
  canvasColor: const Color(0xffF5F4F2),
  scaffoldBackgroundColor: const Color(0xffFFFFFF),
  bottomAppBarColor: const Color(0xffffffff),
  cardColor: const Color(0xffffffff),
  dividerColor: const Color(0xffd2d2d2),
  highlightColor: const Color(0xFFA5A5A5),
  splashColor: const Color(0x66c8c8c8),
  selectedRowColor: const Color(0xfff5f5f5),
  unselectedWidgetColor: const Color(0x8a000000),
  disabledColor: const Color(0x61000000),
  toggleableActiveColor: const Color(0xffb91d13),
  secondaryHeaderColor: const Color(0xfffde9e8),
  backgroundColor: const Color(0xfff5a7a3),
  dialogBackgroundColor: const Color(0xffffffff),
  indicatorColor: const Color(0xffe72418),
  hintColor: const Color(0xff3F3D56),
  errorColor: const Color(0xffd32f2f),
  appBarTheme: const AppBarTheme(backgroundColor: Colors.deepPurple),
  buttonTheme: const ButtonThemeData(),
);

ThemeData getLightTheme() => _lightTheme;
