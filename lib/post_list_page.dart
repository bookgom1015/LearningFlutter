import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/tag_list.dart';
import 'package:flutter_application_learning/entries/post.dart';
import 'package:flutter_application_learning/components/search_bar.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/globals.dart' as globals;
import 'package:http/http.dart' as http;

class PostListPage extends StatefulWidget {
  final User user;
  final Subscriptions subs;
  final BuildContext context;
  final PageController pageController;

  const PostListPage({
    Key? key,
    required this.user,
    required this.subs,
    required this.context, 
    required this.pageController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PostListPageState();  
}

class _PostListPageState extends State<PostListPage> {
  late List<Post> _postList;

  final List<String> _dropDownMenuItemList = [
    "One", "Two", "Three", "Four"
  ];

  final FocusNode _searchBarFocusNode = FocusNode();
  final TextEditingController _searchBarController = TextEditingController();

  @override
  void initState() {
    _postList = [];

    StringBuffer uri = StringBuffer();
    uri.write(globals.SpringUriPath);
    uri.write("/api/post");

    var response = http.get(Uri.parse(uri.toString()));

    response.then((value) {
      if (value.statusCode != 200) {
        print("error occured");
      }
      else {
        List<dynamic> posts = jsonDecode(value.body);
        for (var post in posts) {
          _postList.add(Post.fromJson(post));
        }
      }
    });

    widget.pageController.addListener(() {
      if(_searchBarFocusNode.hasFocus) {
        SearchBarLostedFocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchBarFocusNode.dispose();
    _searchBarController.dispose();
  }

  // ignore: non_constant_identifier_names
  void SearchBarLostedFocus() {
    _searchBarFocusNode.unfocus();
    _searchBarController.clear();
  }

  @override
  Widget build(BuildContext context) {
    const double margin = 5;
    const double padding = 15;
    const double innerPadding = 10;

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double actualWidth = deviceWidth - padding - padding - innerPadding - innerPadding;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(padding, 10, padding, 0),
        decoration: const BoxDecoration(
          color: globals.BackgroundColor
        ),
        child: Column(
          children: [
            SearchBar(
              focusNode: _searchBarFocusNode,
              controller: _searchBarController,
              dropDownMenuItemList: _dropDownMenuItemList
            ),
            Expanded(
              child: groupListView(
                height: 190,
                titleHeight: 40,
                titleFontSize: 18,
                descHeight: 70,
                maxLines: 3,
                tagsWidth: actualWidth,
                tagsHeight: 20, 
                imageSize: 40,
                margin: margin, 
                padding: innerPadding
              )
            )
          ],
        ),
      ),
    );
  }

  Widget groupListView({
      required double height,
      required double titleHeight,
      required double titleFontSize,
      required double descHeight,
      required int maxLines,
      required double tagsWidth, 
      required double tagsHeight,
      required double imageSize,
      required double margin,
      required double padding}) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: globals.ListViewBottomPadding),
      itemCount: _postList.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () {
            if(_searchBarFocusNode.hasFocus) {
              SearchBarLostedFocus();
            }
            
          },
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
                  TagList(width: tagsWidth, height: tagsHeight, tagList: _postList[index].tags),
                  // Title
                  SizedBox(
                    height: titleHeight,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _postList[index].title,
                        style: TextStyle(
                          color: globals.FocusedForeground,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    )
                  ),
                  // Descriptors
                  SizedBox(
                    height: descHeight,
                    child: Text(
                      _postList[index].desc,
                      maxLines: maxLines,
                      style: const TextStyle(
                        color: globals.FocusedForeground,
                        overflow: TextOverflow.ellipsis
                      ),
                    )
                  ),
                  // Image and host
                  Row(
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
                        _postList[index].id.toString(),
                        style: const TextStyle(
                          color: globals.FocusedForeground
                        ),
                      )
                    ],
                  )
                ],                        
              )
            ),
          )
        );
      },
    );
  }
}