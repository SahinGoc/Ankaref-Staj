import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeMode themeMode = ThemeMode.dark;
  
  bool get isDarkMode => themeMode == ThemeMode.system;

  void toggleTheme(bool toggle){
    themeMode = toggle ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyTheme{

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(),
    primaryColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white,),
    bottomAppBarColor: Color.fromRGBO(54,69,79,0.7),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color.fromRGBO(54,69,79,1)),
    cardColor: Colors.grey.shade700,
  );

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(),
    primaryColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black,),
    bottomAppBarColor: Color.fromRGBO(236,227,252,0.7),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color.fromRGBO(236,227,252,1)),
    cardColor: Colors.white54,
  );
}