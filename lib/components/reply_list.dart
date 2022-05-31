import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/comment.dart';

Widget createReplyListView(
    List<Comment> replies, {
      Color backgroundColors1 = Colors.white,
      Color backgroundColors2 = Colors.black,
      Color shadowColor = Colors.black,
      BorderRadiusGeometry? borderRadius,
      EdgeInsetsGeometry contentPadding = EdgeInsets.zero,
      EdgeInsetsGeometry margin = EdgeInsets.zero,
      EdgeInsetsGeometry padding = EdgeInsets.zero}) {
  return ListView.builder(                  
    padding: contentPadding,
    itemCount: replies.length,
    itemBuilder: (_, index) {
      return Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            stops: const [
              0.0,
              0.5
            ],
            colors: [
              backgroundColors1,
              backgroundColors2,
            ]
          ),
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(6, 8)
            )
          ]
        ),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      image: AssetImage(replies[index].user.userProfile.filePath),
                    )
                  )
                ),
                Text(
                  replies[index].user.userNickname,
                  style: const TextStyle(
                    color: Colors.black
                  )
                )
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                child: Text(
                  replies[index].desc,
                  style: const TextStyle(
                    color: Colors.black
                  ),
                ),
              )
            )
          ],
        ),
      );
    }
  );
}