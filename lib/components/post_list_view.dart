
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/tag_list.dart';
import 'package:flutter_application_learning/entries/post.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

Widget createPostListView({
  required List<Post> posts,
  required VoidCallback onTab,
  required double height,
  required double titleHeight,
  required double imageSize,
  required double tagsWidth,
  required double tagsHeight,
  int maxLines = 1,
  double margin = 0,
  double padding = 0,
  double bottomPadding = 0,
  double titleFontSize = 15,
}) {
  return ListView.builder(
    padding: EdgeInsets.only(bottom: bottomPadding),
    itemCount: posts.length,
    itemBuilder: (_, index) {
      return GestureDetector(
        onTap: onTab,
        child: Container(
          height: height,
          margin: EdgeInsets.fromLTRB(0, margin, 0, margin),
          decoration: BoxDecoration(
            color: globals.IdentityColor,
            borderRadius: globals.DefaultRadius
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags
                TagList(width: tagsWidth, height: tagsHeight, tagList: posts[index].tags),
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
                        posts[index].id.toString(),
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