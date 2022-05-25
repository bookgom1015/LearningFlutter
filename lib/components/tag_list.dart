import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/string_helper.dart';

class TagList extends StatelessWidget {
  final double width;
  final double height;
  final List<String> tags;
  final Color fontColor;
  final Color backgroundColor;
  final Color shadowColor;

  const TagList({
    Key? key, 
    required this.width, 
    required this.height, 
    required this.tags,
    required this.fontColor,
    required this.backgroundColor,
    required this.shadowColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double margin = 5;
    const double padding = 5;

    double extraSpace = margin + padding + padding;
    double accum = 0;

    var textStyle = TextStyle(
      color: fontColor,
      fontSize: 12,
      fontWeight: FontWeight.bold
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
            itemCount: tags.length,
            itemBuilder: (_, tagIndex) {
              String tagText = tags[tagIndex];
              double textWidth = calcTextSize(tagText, textStyle).width + extraSpace;

              accum += textWidth;
              if (accum > width) {
                return const SizedBox(width: 0, height: 0);
              }

              if ((tagIndex + 1) < tags.length) {
                String nextTagText = tags[tagIndex + 1];
                // ignore: non_constant_identifier_names
                double NextTextWidth = calcTextSize(nextTagText, textStyle).width + extraSpace;
                if ((accum + NextTextWidth) > width) {
                  tagText = "...";
                }
              }

              return Container(
                margin: const EdgeInsets.only(right: margin),
                padding: const EdgeInsets.fromLTRB(padding, 0, padding, 0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: const Offset(2, 2)
                    )
                  ]
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