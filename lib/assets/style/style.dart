import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xFF372041),
  primaryColor: Color(0xFF372041),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF372041),
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
    ),
  ),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF372041),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
  ),
);