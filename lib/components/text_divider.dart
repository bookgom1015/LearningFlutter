import 'package:flutter/material.dart';

Widget createTextDivider(
    String text, {
      double? height,
      Color fontColor = Colors.grey,
      Color underlineColor = Colors.grey}) {
  return SizedBox(
    height: height,
    child: Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: fontColor
          )        
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 1,
            child: Divider(
              color: underlineColor,
              thickness: 1,
            )
          )
        )
      ]
    )
  );
}