import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppBarBtn extends StatelessWidget {
  IconData icon;
  Function func;
  Color color;

  AppBarBtn({
    Key? key,
    required this.icon, 
    required this.color,
    required this.func}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: func(),
      color: color,
      icon: Icon(icon)
    );
  }
}