import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/post_list_view.dart';
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
              child: createPostListView(
                posts: _postList, 
                onTab: () {
                  if(_searchBarFocusNode.hasFocus) {
                    SearchBarLostedFocus();
                  }

                }, 
                height: 180, 
                titleHeight: 40, 
                imageSize: 40, 
                tagsWidth: actualWidth, 
                tagsHeight: 20,
                maxLines: 3,
                margin: margin,
                padding: innerPadding,
                bottomPadding: globals.ListViewBottomPadding,
                titleFontSize: 18
              )
            )
          ],
        ),
      ),
    );
  }
}