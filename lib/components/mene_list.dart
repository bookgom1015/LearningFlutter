import 'package:flutter/material.dart';
import 'package:flutter_application_learning/entries/menu.dart';

Widget createMenuListView({
  required BuildContext context,
  required List<Menu> menus,
  required int index,
  Color bottomRightColor = Colors.transparent,
  Color topLeftColor = Colors.transparent,
  Color shadowColor = Colors.black,
  BorderRadiusGeometry? borderRadius,
}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context, 
          menus[index].routeName,
          arguments: menus[index].arguments
        ).then((value) {
          if (menus[index].then != null) {
            menus[index].then!();
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            stops: const [
              0.0,
              0.5
            ],
            colors: [
              bottomRightColor,
              topLeftColor,
            ]
          ),
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(6, 8)
            )
          ]
        ),
        height: 70,
        child: Row(
          children: [
            Icon(
              menus[index].icon,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              menus[index].title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600
              )
            )
          ]
        )
      )
    );
  }