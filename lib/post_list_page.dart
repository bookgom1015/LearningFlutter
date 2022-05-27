import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/loading.dart';
import 'package:flutter_application_learning/components/post_list_view.dart';
import 'package:flutter_application_learning/entries/post.dart';
import 'package:flutter_application_learning/components/search_bar.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;

class PostListPage extends StatefulWidget {
  final KeyValueStorage storage;
  final BuildContext context;
  final PageController pageController;

  const PostListPage({
    Key? key,
    required this.storage,
    required this.context, 
    required this.pageController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PostListPageState();  
}

class _PostListPageState extends State<PostListPage> {
  List<Post> _posts = [];

  final FocusNode _searchBarFocusNode = FocusNode();
  final TextEditingController _searchBarController = TextEditingController();

  bool _loaded = false;
  bool _clicked = false;

  String _requirement = "";
  String _query = "";

  @override
  void initState() {
    widget.pageController.addListener(() {
      if(_searchBarFocusNode.hasFocus) {
        searchBarLostedFocus();
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    generatePosts();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _searchBarFocusNode.dispose();
    _searchBarController.dispose();
  }

  // ignore: non_constant_identifier_names
  void searchBarLostedFocus() {
    _searchBarFocusNode.unfocus();
    _searchBarController.clear();
  }

  void generatePosts() async {
    int statusCode = await getPosts((list) {
      setState(() {
        _posts = list;
        _loaded = true;
      });
    });
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
    }
  }

  void onSearchButtonClicked() async {
    int statusCode = await searchPosts(
      _requirement, 
      _query, 
      (list) {
        setState(() {
          _posts = list;
          _loaded = true;
        });
        _clicked = false;
      }
    );
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
    }
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
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 1),
              dropdownColor: globals.DropdownColor,
              focusedColor: globals.FocusedForeground,
              unfocusedColor: globals.UnfocusedForeground,
              onTap: () {
                if (!_clicked) {
                  _clicked = true;
                  setState(() {
                    _loaded = false;
                  });
                  onSearchButtonClicked();
                }
              },
              onChanged: (String value) {
                _query = value;
              },
              onDropdownChanged: (String value) {
                _requirement = value;
              },
            ),
            Expanded(
              child: _loaded ? Stack(
                children: [
                  createPostListView(
                    posts: _posts, 
                    onTab: (index) {
                      if(_searchBarFocusNode.hasFocus) {
                        searchBarLostedFocus();
                      }

                      Navigator.pushNamed(
                        widget.context, "/post",
                        arguments: {
                          "index": index,
                          "storage": widget.storage,
                          "post": _posts[index],
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
                  ),
                  Container(
                    height: 30,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          globals.BackgroundColor,
                          Color.fromARGB(0, 233, 232, 232),
                        ]
                      )
                    ),
                  )
                ]
              ) : loading()
            ) 
          ],
        ),
      ),
    );
  }
}