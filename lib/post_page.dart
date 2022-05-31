import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/add_button.dart';
import 'package:flutter_application_learning/components/comment.dart';
import 'package:flutter_application_learning/components/fade_out.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/reply_list.dart';
import 'package:flutter_application_learning/entries/post.dart';
import 'package:flutter_application_learning/entries/reply.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
import 'package:flutter_application_learning/entries/user.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with SingleTickerProviderStateMixin {
  Map _receivedData = {};

  late KeyValueStorage _storage;
  late User _user;
  late Post _post;

  final double _shrinkeddHeight = 50;
  bool isExtended = false;

  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _heightAnimation;

  List<Comment> _replies = [];

  late double _deviceWidth;
  late double _extendedHeight;
  late double _viewHeight;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: globals.ShorterAnimDuration)
    );

    _curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic
    );

    _heightAnimation = Tween<double>(
      begin: 0,
      end: 1
    ).animate(_curveAnimation);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _deviceWidth = MediaQuery.of(context).size.width;
    _extendedHeight = MediaQuery.of(context).size.height * 0.5;    
    _viewHeight = MediaQuery.of(context).size.height
                    - MediaQuery.of(context).padding.top // Status bar height
                    - AppBar().preferredSize.height - _shrinkeddHeight;

    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    _storage = _receivedData["storage"];
    _post = _receivedData["post"];
    _user = User.fromJson(jsonDecode(_storage.get("user")));

    generateComments();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  void onExtensionButtonClicked() {
    setState(() {
      isExtended = !isExtended;
      if (isExtended) {
        _controller.forward();
      }
      else {
        _controller.reverse();
      }
    });
  }

  void onAddButtonClicked() {
    Navigator.pushNamed(
      context, 
      "/add_reply",
      arguments: {
        "storage": _storage,
        "post": _post
      }
    );
  }

  void generateComments() async {
    int statusCode = await getReplies(
      _user.token,
      _post.group.id, 
      _post.id, 
      (list) {
        setState(() {
          _replies = list;
        });
      }
    );
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight,
          title: _post.title,
          backgroundColor: globals.AppBarColor
        ),
        body: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, _) { 
            return Container(
              decoration: const BoxDecoration(
                color: globals.BackgroundColor
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: contentWidget(_viewHeight)
                    )
                  ),
                  SizedBox(
                    height: _shrinkeddHeight + _heightAnimation.value * (_extendedHeight - _shrinkeddHeight),
                    child: repliesWidget(_deviceWidth)
                  )
                ]
              )
            );
          }
        )
      ),
    );
  }

  Widget contentWidget(double viewHeight) {      
    return Container(
      margin: const EdgeInsets.all(10),
      constraints: BoxConstraints(
        minHeight: viewHeight - 20 // to exclude margin
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          stops: [
            0.0,
            0.5
          ],
          colors: [
            globals.ContentBackgroundColors1,
            globals.ContentBackgroundColors2,
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
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and host
            Row(
              children: [
                Hero(
                  tag: "post_" + _receivedData['index'].toString(),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(_post.user.userProfile.filePath)
                      )
                    ),
                  )
                ),
                Text(
                  _post.user.userNickname,
                  style: const TextStyle(
                    color: globals.FocusedForeground
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Text(
                    _post.desc,
                    maxLines: null,
                    style: const TextStyle(
                      color: globals.FocusedForeground
                    ),
                  )
                ),                      
              ],
            )
          ],                  
        )
      ),
    );
  }

  Widget repliesWidget(double width) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [
            0.1,
            0.3
          ],
          colors: [
            globals.RepliesBackgroundColors1,
            globals.RepliesBackgroundColors2,
          ]
        ),
        boxShadow: [
          BoxShadow(
            color: globals.ShadowColor,
            spreadRadius: 1,
            blurRadius: 16,
            offset: Offset(0, -4)
          )
        ]
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,                                  
                ),
                width: width,
                height: _shrinkeddHeight,
                child: GestureDetector(
                  onTap: onExtensionButtonClicked,
                  child: Icon(
                    isExtended ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                    color: globals.FocusedForeground,
                  )
                ),
              )
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                createReplyListView(
                  _replies,
                  backgroundColors1: globals.RepliesListViewItemBackgroundColors1,
                  backgroundColors2: globals.RepliesListViewItemBackgroundColors2,
                  shadowColor: globals.ShadowColor,
                  borderRadius: globals.DefaultRadius,
                  contentPadding: const EdgeInsets.only(top: 20, bottom: 90),
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 12),
                  padding: const EdgeInsets.all(10),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: createAddButton(
                    onTap: onAddButtonClicked,
                    backgroundColors1: globals.AddRepliesButtonBackgroundColors1,
                    backgroundColors2: globals.AddRepliesButtonBackgroundColors2,
                    shadowColor: globals.ShadowColor
                  )
                ),
                cretaeFadeOut(
                  globals.RepliesBackgroundColors2,
                  const Color.fromARGB(0, 233, 232, 232)
                )
              ],
            )
          )
        ],
      ),
    );
  }
}