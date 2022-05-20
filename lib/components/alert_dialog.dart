import 'package:flutter/material.dart';

void showAlertDialog({
    required BuildContext context,
    String text = "",
    Color fontColor = Colors.black,
    Color backgroundColor = Colors.white,
    BorderRadius borderRadius = BorderRadius.zero}) {
  showDialog(context: context, builder: (BuildContext _) {
    return AlertDialog(
      title: Text(
        "알림",
        style: TextStyle(
          color: fontColor
        )
      ),
      content: Text(
        text,
        softWrap: true,
        style: TextStyle(
          color: fontColor
        )
      ),
      backgroundColor: backgroundColor,
      elevation: 24,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("OK"),
        ),
      ],
    );
  });
}