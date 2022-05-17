import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/tag_list.dart';
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

Widget createGroupListView({
    required List<Group> groups,
    required void Function(int) onTab,
    required double width,
    required double height,
    required double tagsHeight,
    required double imageSize,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets descPadding = EdgeInsets.zero,}) {
  final double actualWidth = width - margin.left - margin.right - padding.left - padding.right - 
                                descPadding.left - descPadding.right - imageSize;
  final double titleHeight = height - tagsHeight - padding.top - padding.bottom;
    
  return ListView.builder(
    padding: const EdgeInsets.only(bottom: globals.ListViewBottomPadding),
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
            color: globals.IdentityColor,
            borderRadius: globals.DefaultRadius
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
                    TagList(width: actualWidth, height: tagsHeight, tagList: groups[index].tags)          
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