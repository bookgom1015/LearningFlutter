import 'package:flutter/material.dart';

Widget underlineInputfiled({
    required FocusNode focusNode,
    required Color fontColor,
    required Color hintFontColor,
    required Function(String) onChanged,
    required Color underlineColor,    
    String text = "",
    String hintText = "",
    double width = 40,
    double interval = 10,
    double height = 1,
    double thickness = 1}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          SizedBox(
            width: width,
            child: Text(text)
          ),
          SizedBox(width: interval),
          Expanded(
            child: TextFormField(
              focusNode: focusNode,
              style: TextStyle(
                color: fontColor
              ),
              decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                hintText: hintText,
                hintStyle: TextStyle(
                  color: hintFontColor
                )
              ),
              onChanged: onChanged
            )
          )            
        ]
      ),
      SizedBox(
        height: height,
        child: Divider(
          color: underlineColor,
          thickness: thickness,
        )
      )        
    ]
  );
}