import 'package:flutter/material.dart';
import 'utils/colors.dart';

class EMTheme {
  OutlineInputBorder customOutline(
      {double width = 1, double borderRadius = 5, Color color = Colors.grey}) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: color, width: width));
  }

  InputDecorationTheme customInput() {
    return InputDecorationTheme(
      focusedBorder: customOutline(color: onSecondary, width: 2),
      enabledBorder: customOutline(),
      border: customOutline(),
      contentPadding: const EdgeInsets.all(10),
    );
  }

  ButtonThemeData buttonTheme() {
    return const ButtonThemeData(
      padding: EdgeInsets.all(15),
      buttonColor: primary,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }

  ThemeData lightTheme() {
    return ThemeData(
      iconTheme: const IconThemeData(
        color: onBackground,
      ),
      primaryColor: primary,
      buttonTheme: buttonTheme(),
      inputDecorationTheme: customInput(),
      appBarTheme: appBarThemeLight(),
      scaffoldBackgroundColor: surface,
      colorScheme: const ColorScheme(
        primary: primary,
        brightness: Brightness.light,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        error: error,
        onError: onError,
        background: background,
        onBackground: onBackground,
        surface: surface,
        onSurface: onSurface,
      ),
      dividerTheme: dividerTheme(),
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      iconTheme: const IconThemeData(color: background),
      buttonTheme: buttonTheme(),
      inputDecorationTheme: customInput(),
      primaryColor: primary,
      appBarTheme: appBarThemeDark(),
      scaffoldBackgroundColor: onSurface,
      colorScheme: const ColorScheme(
        primary: primary,
        brightness: Brightness.dark,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        error: error,
        onError: onError,
        background: darkBackground,
        onBackground: darkOnBackground,
        surface: darkSurface,
        onSurface: darkOnSurface,
      ),
      dividerTheme: dividerTheme(),
    );
  }
  DividerThemeData dividerTheme() {
    return const DividerThemeData(
      color: Colors.black12,
    );
  }

  AppBarTheme appBarThemeLight() {
    return const AppBarTheme(
      backgroundColor: surface,
      surfaceTintColor: surface,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(color: onSurface),
    );
  }

  AppBarTheme appBarThemeDark() {
    return const AppBarTheme(
      backgroundColor: onSurface,
      surfaceTintColor: onSurface,
      elevation: 2,
      titleTextStyle: TextStyle(
        color: surface,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(color: surface),
    );
  }
}

/*
*
*
* */
