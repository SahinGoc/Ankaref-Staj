import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp_staj/screens/to_do_list.dart';
import 'package:todoapp_staj/theme/my_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    builder: (context, _) {
      final themeProvider = Provider.of<ThemeProvider>(context);

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: themeProvider.themeMode,
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        home: ToDoListScreen(),
      );
    },
  );
}