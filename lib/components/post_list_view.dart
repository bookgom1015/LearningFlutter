
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/tag_list.dart';
import 'package:flutter_application_learning/entries/post.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;

Widget createPostListView({
    required List<Post> posts,
    required void Function(int) onTab,
    required double height,
    required double titleHeight,
    required double imageSize,
    required double tagsWidth,
    required double tagsHeight,
    int maxLines = 1,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets viewItemPadding = EdgeInsets.zero,
    double titleFontSize = 15}) {
  return ListView.builder(
    padding: viewItemPadding,
    itemCount: posts.length,
    itemBuilder: (_, index) {
      return GestureDetector(
        onTap: () {
          onTab(index);
        },
        child: Container(
          height: height,
          margin: margin,
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
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags
                TagList(
                  width: tagsWidth, 
                  height: tagsHeight, 
                  tags: posts[index].tags,
                  fontColor: globals.FocusedForeground,
                  backgroundColor: globals.TagBackgroundColor,
                  shadowColor: globals.ShadowColor
                ),
                // Title
                SizedBox(
                  height: titleHeight,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      posts[index].title,
                      style: TextStyle(
                        color: globals.FocusedForeground,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  )
                ),
                // Descriptors
                Expanded(
                  child: Text(
                    posts[index].desc,
                    maxLines: maxLines,
                    style: const TextStyle(
                      color: globals.FocusedForeground,
                      overflow: TextOverflow.ellipsis
                    ),
                  )
                ),
                // Image and host
                SizedBox(
                  height: imageSize,
                  child: Row(
                    children: [
                      Hero(
                        tag: "post_" + index.toString(),
                        child: Container(
                          width: imageSize,
                          height: imageSize,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage("assets/images/creeper_128x128.jpg"))
                          ),
                        )
                      ),
                      Text(
                        posts[index].user.userNickname,
                        style: const TextStyle(
                          color: globals.FocusedForeground
                        ),
                      )
                    ],
                  )
                )
              ],                        
            )
          ),
        )
      );
    },
  );
}