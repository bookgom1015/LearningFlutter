import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_application_learning/globals.dart' as globals;

class TagList extends StatelessWidget {
  final double width;
  final double height;
  final List<String> tagList;

  const TagList({Key? key, required this.width, required this.height, required this.tagList}) : super(key: key);

  Size calcTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    const double margin = 5;
    const double padding = 10;
    double doublePadding = padding + padding;
    double accum = 0;

    var textStyle = const TextStyle(
      color: globals.FocusedForeground,
      fontSize: 12
    );

    return SizedBox(
      width: width,
      height: height,
      child: Row(
        children: [
          ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tagList.length,
            itemBuilder: (_, tagIndex) {
              String tagText = tagList[tagIndex];
              double textWidth = calcTextSize(tagText, textStyle).width + doublePadding + margin;

              if ((accum + textWidth) > width) {
                return const SizedBox(width: 0, height: 0);
              }
              accum += textWidth;

              if (tagIndex + 2 < tagList.length) {
                String nextTagText = tagList[tagIndex + 1];
                double NextTextWidth = calcTextSize(nextTagText, textStyle).width + doublePadding + margin;

                if ((accum + NextTextWidth) > width) {
                  tagText = "...";
                }
              }

              return Container(
                margin: const EdgeInsets.only(right: margin),
                padding: const EdgeInsets.fromLTRB(padding, 0, padding, 0),
                decoration: BoxDecoration(
                  color: globals.IdentityColorLighter30,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Center(
                  child: Text(
                    tagText,
                    style: textStyle
                  )
                )
              );
            }
          )
        ],
      )
    );
  }
}