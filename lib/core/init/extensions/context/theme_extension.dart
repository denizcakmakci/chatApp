import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  Color get primaryColor => theme.primaryColor;
  Color get backgroundLight => theme.scaffoldBackgroundColor;
  Color get canvasColor => theme.canvasColor;
  Color get errorColor => theme.errorColor;
  Color get primaryLightColor => theme.primaryColorLight;
  Color get primaryDarkColor => theme.primaryColorDark;
  Color get lightPink => const Color(0xffFFE6D2);

  TextStyle get headline1 => theme.textTheme.headline1!
      .copyWith(fontWeight: FontWeight.w600, color: primaryLightColor);
  TextStyle get headline2 => theme.textTheme.headline2!.copyWith(
      fontSize: 30, fontWeight: FontWeight.bold, color: primaryLightColor);
  TextStyle get headline3 => theme.textTheme.headline3!.copyWith(
      fontSize: 25,
      fontWeight: FontWeight.w600,
      color: primaryLightColor.withOpacity(.9));
  TextStyle get headline4 => theme.textTheme.headline4!
      .copyWith(fontSize: 20, color: primaryLightColor);
  TextStyle get headline5 => theme.textTheme.headline5!
      .copyWith(fontSize: 18, color: primaryLightColor);
  TextStyle get headline6 => theme.textTheme.headline6!
      .copyWith(fontSize: 16, color: primaryLightColor);
}
