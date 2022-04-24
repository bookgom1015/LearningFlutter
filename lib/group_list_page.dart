import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/search_bar.dart';
import 'package:flutter_application_learning/components/tag_list.dart';
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class GroupListPage extends StatefulWidget {
  final BuildContext context;
  final PageController pageController;

  const GroupListPage({Key? key, required this.context, required this.pageController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  final List<Group> _groups = [
    Group("assets/images/creeper_128x128.jpg", "Title 1", "Host 1", ["C", "C", "C", "C", "C", "C", "C", "C", "C", "C", "C"]),
    Group("assets/images/creeper_128x128.jpg", "Title 2", "Host 2", ["C", "C++", "C", "C++", "C", "C++", "C", "C++", "C", "C++", "C", "C++"]),
    Group("assets/images/creeper_128x128.jpg", "Title 3", "Host 3", ["C", "C++", "C#", "F#", "Xamarin"]),
    Group("assets/images/creeper_128x128.jpg", "Title 5", "Host 5", ["Java", "Kotlin"]),
    Group("assets/images/creeper_128x128.jpg", "Title 6", "Host 6", ["Android"]),
    Group("assets/images/creeper_128x128.jpg", "Title 7", "Host 7", ["Android", "IOS", "Java", "Swing", "Mac", "Windows", "Linux", "Assembly"]),
    Group("assets/images/creeper_128x128.jpg", "Title 8", "Host 8", ["Windows", "Linux"]),
    Group("assets/images/creeper_128x128.jpg", "Title 9", "Host 9", ["Go", "Ruby", "R"]),
    Group("assets/images/creeper_128x128.jpg", "Title 10", "Host 10", ["OpenCL"]),
    Group("assets/images/creeper_128x128.jpg", "Title 11", "Host 11", ["OpenGL", "DirectX"]),
    Group("assets/images/creeper_128x128.jpg", "Title 12", "Host 12", ["Vulkan", "OpenGL"]),
    Group("assets/images/creeper_128x128.jpg", "Title 13", "Host 13", ["Skia", "Direct2D"]),
  ];

  final List<String> _dropDownMenuItemList = [
    "One", "Two", "Three", "Four"
  ];

  final FocusNode _searchBarFocusNode = FocusNode();
  final TextEditingController _searchBarController = TextEditingController();

  @override
  void initState() {
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
  Widget build(BuildContext _) {
    const double margin = 5;
    const double outerPadding = 15;
    const double innerPadding = 15;
    const double imageBoxSize = 40;
    const double containerHeight = 70;
    double deviceWidth = MediaQuery.of(context).size.width;
    double actualWidth = deviceWidth - outerPadding - outerPadding - innerPadding - innerPadding;
    double postDescWidth = actualWidth - imageBoxSize;

    return Scaffold(
      backgroundColor: globals.BackgroundColor,
      body: Container(
        padding: const EdgeInsets.fromLTRB(outerPadding, 10, outerPadding, 0),
        child: Column(
          children: [
            SearchBar(
              focusNode: _searchBarFocusNode,
              controller: _searchBarController,
              dropDownMenuItemList: _dropDownMenuItemList,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: _groups.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      if(_searchBarFocusNode.hasFocus) {
                        SearchBarLostedFocus();
                      }
                      Navigator.pushNamed(
                        widget.context, "/detail_group",
                        arguments: { "index": index, "image": _groups[index].image }
                      );
                    },
                    child: Container(
                      height: containerHeight,
                      padding: const EdgeInsets.fromLTRB(innerPadding, 0, innerPadding, 0),
                      margin: const EdgeInsets.fromLTRB(0, margin, 0, margin),
                      decoration: BoxDecoration(
                        color: globals.IdentityColor,
                        borderRadius: globals.DefaultRadius
                      ),
                      child: Row(
                        children: [
                          ImageBox(40, index),
                          PostDesc(postDescWidth, imageBoxSize, index),
                        ],
                      )
                    ),
                  );
                },
              )
            )
          ]
        )
      )
    );
  }

  // ignore: non_constant_identifier_names
  Widget ImageBox(double size, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(tag: index.toString(), 
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
               image: AssetImage(_groups[index].image)
              )
            )
          )
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget PostDesc(double width, double height, int index) {
    const double padding = 15;
    double actualWidth = width - padding - padding;
    double tagsHeight = 20;
    double titleHeight = height - tagsHeight;

    return Padding(
      padding: const EdgeInsets.fromLTRB(padding, 0, padding, 0),
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
                  _groups[index].title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: globals.FocusedForeground
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _groups[index].host,
                  style: const TextStyle(
                    fontSize: 11,
                    color: globals.FocusedForeground
                  ),
                ),
              ],
            )
          ),
          TagList(width: actualWidth, height: tagsHeight, tagList: _groups[index].tags)          
        ],
      )
    );
  }
}