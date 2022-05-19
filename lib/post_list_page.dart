import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/loading.dart';
import 'package:flutter_application_learning/components/post_list_view.dart';
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
  List<Post> _postList = [];

  final List<String> _dropDownMenuItemList = [
    "One", "Two", "Three", "Four"
  ];

  final FocusNode _searchBarFocusNode = FocusNode();
  final TextEditingController _searchBarController = TextEditingController();

  bool _loaded = false;

  void getPostList() async {
    StringBuffer uri = StringBuffer();
    uri.write(globals.SpringUriPath);
    uri.write("/api/post");

    var response = await http.get(Uri.parse(uri.toString()));

    if (response.statusCode != 200) {
      print("error occured: " + response.statusCode.toString());
      return;
    }

    List<Post> postList = [];

    List<dynamic> jsonArray = jsonDecode(response.body);
    for (var json in jsonArray) {
      postList.add(Post.fromJson(json));
    }

    setState(() {
      _postList = postList;
      _loaded = true;
    });
  }

  @override
  void initState() {
    getPostList();

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
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: globals.BackgroundColor
        ),
        child: Column(
          children: [
            SearchBar(
              focusNode: _searchBarFocusNode,
              controller: _searchBarController,
              dropDownMenuItemList: _dropDownMenuItemList,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0)
            ),
            Expanded(
              child: _loaded ? createPostListView(
                posts: _postList, 
                onTab: (index) {
                  if(_searchBarFocusNode.hasFocus) {
                    SearchBarLostedFocus();
                  }

                  Navigator.pushNamed(
                    widget.context, "/post",
                    arguments: {
                      "index": index,
                      "post": _postList[index],
                    }
                  );
                }, 
                height: 180, 
                titleHeight: 40, 
                imageSize: 40, 
                tagsWidth: deviceWidth, 
                tagsHeight: 20,
                maxLines: 3,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                padding: const EdgeInsets.all(10),
                viewItemPadding: const EdgeInsets.only(top: 20, bottom: 110),
                titleFontSize: 18
              ) : loading()
            ) 
          ],
        ),
      ),
    );
  }
}