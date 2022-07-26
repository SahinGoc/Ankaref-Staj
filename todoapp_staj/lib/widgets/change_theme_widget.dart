import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp_staj/theme/my_theme.dart';

class ChangeThemeWidget extends StatefulWidget {
  @override
  _ChangeThemeWidgetState createState() => _ChangeThemeWidgetState();
}

class _ChangeThemeWidgetState extends State{

  bool toggle = false;

  @override
  Widget build(BuildContext context) {

    return IconButton(
      color: Theme.of(context).iconTheme.color,
        icon: toggle
            ? Icon(Icons.wb_sunny)
            : Icon(Icons.nightlight_round),
        onPressed: () {
          setState(() {
            final provider = Provider.of<ThemeProvider>(context,listen: false);
            toggle = !toggle;
            provider.toggleTheme(toggle);
          });
        });

  }
}


