import 'package:flutter/material.dart';

class AppBarBtn extends StatelessWidget {
  IconData btnIcon;
  Function btnFunc;

  AppBarBtn({Key? key, required this.btnIcon, required this.btnFunc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: btnFunc(),
      icon: Icon(btnIcon)
    );
  }
}