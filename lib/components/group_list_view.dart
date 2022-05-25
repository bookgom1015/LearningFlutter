import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/tag_list.dart';
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;

Widget createGroupListView({
    required List<Group> groups,
    required void Function(int) onTab,
    required double width,
    required double height,
    required double tagsHeight,
    required double imageSize,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets descPadding = EdgeInsets.zero,
    EdgeInsets viewItemPadding = EdgeInsets.zero,}) {
  final double actualWidth = width - margin.left - margin.right - padding.left - padding.right - 
                                descPadding.left - descPadding.right - imageSize;
  final double titleHeight = height - tagsHeight - padding.top - padding.bottom;
    
  return ListView.builder(
    padding: viewItemPadding,
    itemCount: groups.length,
    itemBuilder: (_, index) {
      return GestureDetector(
        onTap: () {
          onTab(index);
        },
        child: Container(
          height: height,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              stops: [
                0.0,
                0.5
              ],
              colors: [
                globals.ListViewItemBackgroundColors1,
                globals.ListViewItemBackgroundColors2,
              ]
            ),
            borderRadius: globals.DefaultRadius,
            boxShadow: const [
              BoxShadow(
                color: globals.ShadowColor,
                blurRadius: 12,
                spreadRadius: 1,
                offset: Offset(6, 8)
              )
            ]
          ),
          child: Row(
            children: [
              // Profile
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "group_" + index.toString(), 
                    child: Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                         image: AssetImage(groups[index].filePath)
                        )
                      )
                    )
                  )
                ],
              ),
              // Descriptions
              Padding(
                padding: descPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: actualWidth,
                      height: titleHeight,
                      child: Row(                        
                        children: [
                          Text(
                            groups[index].name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: globals.FocusedForeground
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            groups[index].hostId.toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: globals.FocusedForeground
                            ),
                          ),
                        ],
                      )
                    ),
                    TagList(
                      width: actualWidth,
                      height: tagsHeight,
                      tags: groups[index].tags,
                      fontColor: globals.FocusedForeground,
                      backgroundColor: globals.TagBackgroundColor,
                      shadowColor: globals.ShadowColor
                    )          
                  ],
                )
              ),
            ],
          )
        ),
      );
    },
  );
}