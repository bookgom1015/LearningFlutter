import 'package:flutter/material.dart';

Widget locked({
    required bool isPrivate,
    Color fontColor = Colors.black}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_sharp,
            color: fontColor,
            size: isPrivate ? 64 : 0,
          ),
          Text(
            "똥닌겐 따위에게 권한은 없는데스우",
            style: TextStyle(
              color: fontColor,
              fontSize: isPrivate ? 18 : 0
            )
          )
        ],
      )
    ]
  );
}