import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/heart_anim.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/post_list_view.dart';
import 'package:flutter_application_learning/components/star_anim.dart';
import 'package:flutter_application_learning/components/tag_list.dart';
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/entries/post.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/globals.dart' as globals;
import 'dart:math' as math;
import 'package:http/http.dart' as http;

import 'package:http/http.dart';

class GroupDetailsPage extends StatefulWidget {
  const GroupDetailsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupDetailsPageState();  
}

class _GroupDetailsPageState extends State<GroupDetailsPage> with SingleTickerProviderStateMixin {
  Map _receivedData = {};

  final double _maxHeight = 240;
  final double _triggerVelocity = 250000; // Squared
  late double _middleHeight;
  late double _currHeight;
  double _refHeight = 0;
  double _targetHeight = 0;
  double _prevY = 0;

  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _animation;

  late User _user;
  late Subscriptions _subs;
  late Group _group;

  bool _blocked = true;
  bool _unqualified = false;

  List<Post> _postList = [];

  @override
  void initState() {
    _middleHeight = _maxHeight * 0.5;
    _currHeight = _maxHeight;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: globals.ShorterAnimDuration)
    );

    _curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCirc
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1
    ).animate(_curveAnimation);

    _animation.addListener(() {
      setState(() {
        _currHeight = _refHeight + (_targetHeight - _refHeight) * _controller.value;
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    _user = _receivedData["user"];
    _subs = _receivedData["subs"];
    _group = _receivedData["group"];

    bool isMatched = false;
    for (var group in _subs.groups) {
      if (group.id == _group.id) {
        isMatched = true;
        break;
      }
    }

    if (isMatched || !_group.type) {
      _blocked = false; 
    }

    if (!_blocked && !isMatched) {
      _unqualified = true;
    }

    if (!_blocked) {
      StringBuffer uri = StringBuffer();
      uri.write(globals.SpringUriPath);
      uri.write("/api/team/");
      uri.write(_group.id);
      uri.write("/post");

      var response = http.get(Uri.parse(uri.toString()));

      response.then((value) {
        if (value.statusCode != 200) {
          print("error occured: " + value.statusCode.toString());
        }
        else {
          dynamic posts = jsonDecode(value.body);
          
          List<Post> list = [];
          for (var post in posts) {
            setState(() {
              list.add(Post.fromJson(post));
            });
          }
          _postList = list;
        }
      });
    }
  }

  @override void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height - 
      MediaQuery.of(context).padding.top - // Status bar height
      AppBar().preferredSize.height;
    
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(navTitle: _group.name),
        body: Container(
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: deviceHeight,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          descBox(
                            width: deviceWidth, 
                            height: _maxHeight,
                            tag: "group_" + _receivedData['index'].toString()
                          ),
                          const SizedBox(height: 10),
                          gestureBar(
                            height: 40
                          ),
                          postList(
                            width: deviceWidth,
                            height: 180
                          )
                        ],
                      );
                    }
                  )
                )
              ),
              addPostBtn(
                bottom: 30, 
                right: 30,
                size: 64,
                iconSize: 50
              )
            ]
          )
        )
      )
    );
  }

  Widget descBox({
      required double width,
      required double height,
      required String tag}) {
    return SizedBox(
      width: width,
      height: _currHeight,
      child: FittedBox(
        fit: BoxFit.none,
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            SizedBox(
              width: width,
              height: height - 40,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: globals.IdentityColor,
                        borderRadius: globals.DefaultRadius
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Hero(
                                tag: tag,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(_group.filePath),
                                    )                              
                                  )
                                )
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _group.hostId.toString(),
                                style: const TextStyle(
                                  color: globals.FocusedForeground,
                                  fontSize: 16
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                _group.desc,
                                maxLines: null,
                                style: const TextStyle(
                                  color: globals.FocusedForeground,
                                )
                              )
                            )
                          )
                        ],
                      ),
                    )
                  ),
                  Container(
                    width: 60,
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                      color: globals.IdentityColor,
                      borderRadius: globals.DefaultRadius
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 45,
                          child: IconButton(
                            onPressed: () {}, 
                            icon: const Icon(Icons.add_reaction),
                            color: globals.UnfocusedForeground,
                          ),
                        ),
                        const SizedBox(
                          height: 45,
                          child: StarAnim(beginSize: 24, endSize: 32),
                        ),
                        const SizedBox(
                          height: 45,
                          child: HeartAnim(beginSize: 24, endSize: 32)
                        ),
                        SizedBox(
                          height: 45,
                          child: IconButton(
                            onPressed: () {}, 
                            icon: const Icon(Icons.report),
                            color: globals.FocusedDangerForeground,
                          ),
                        )
                      ]
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(              
              width: width,
              height: 30,
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  color: globals.IdentityColor,
                  borderRadius: globals.DefaultRadius
                ),
                child: TagList(tagList: _group.tags, width: width - 20, height: 20),
              )
            )
          ]
        )
      )
    );
  }

  Widget gestureBar({
      required double height}) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        _prevY = details.globalPosition.dy;
        _refHeight = _currHeight;
      },
      onVerticalDragUpdate: (details) {
        double _deltaY = _prevY - details.globalPosition.dy;
        setState(() {
          _currHeight = math.min(math.max(_refHeight - _deltaY, 0), _maxHeight);
        });
      },
      onVerticalDragEnd: (details) {
        _refHeight = _currHeight;
        var dy = details.velocity.pixelsPerSecond.dy;
        if (dy * dy > _triggerVelocity) {
          if (dy > 0) {
            _targetHeight = _maxHeight;
          }
          else {
            _targetHeight = 0;
          }
        }
        else {
          if (_currHeight > _middleHeight) {
            _targetHeight = _maxHeight;
          }
          else {
            _targetHeight = 0;
          }
        }
        _controller.reset();
        _controller.forward();
      }, 
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: globals.IdentityColorLighter30
        ),
      )
    );
  }

  Widget postList({
      required double width,
      required double height}) {
    Widget lockWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_sharp,
              color: globals.FocusedForeground,
              size: _group.type ? 64 : 0,
            ),
            Text(
              "똥닌겐 따위에게 권한은 없는데스우",
              style: TextStyle(
                color: globals.FocusedForeground,
                fontSize: _group.type ? 18 : 0
              )
            )
          ],
        )
      ]
    );

    const double margin = 10;
    final double actualWidth = width - margin - margin;

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: _blocked ?
              lockWidget :
              createPostListView(
                posts: _postList, 
                onTab: () {}, 
                height: height, 
                titleHeight: 40, 
                imageSize: 40, 
                tagsWidth: actualWidth, 
                tagsHeight: 20,
                maxLines: 3,
                margin: 5,
                padding: 10,
                bottomPadding: 90,
                titleFontSize: 18
              )
            )
          )
        ],
      )
    );
  }

  Widget addPostBtn({
      required double bottom,
      required double right,
      required double size,
      required double iconSize}) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: GestureDetector(
        onTap: () {
          if (_blocked) return;          
          if (_unqualified) {
            showDialog(context: context, builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  "알림",
                  style: TextStyle(
                    color: globals.FocusedForeground
                  )
                ),
                content: const Text(
                  "팀에 소속되어 있지 않습니다. \n글을 작성하시려면 먼저 팀에 가입해주세요.",
                  softWrap: true,
                  style: TextStyle(
                    color: globals.FocusedForeground
                  )
                ),
                backgroundColor: globals.IdentityColor,
                elevation: 24,
                shape: RoundedRectangleBorder(
                  borderRadius: globals.DefaultRadius
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            });
            return;
          }
          Navigator.pushNamed(
            context, "/write_post", 
            arguments: {
              "user": _user,
              "group": _group
            }
          );
        },
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: globals.IdentityColorLighter30,
            boxShadow: [          
              BoxShadow(
                color: globals.ShadowColor,
                spreadRadius: 4,
                blurRadius: 8,
              )
            ]
          ),
          child: Transform.rotate(
            angle: _blocked ? (45 * globals.DegToRad) : 0,
            child: Icon(
              Icons.add,
              color: _blocked ? globals.UnfocusedForeground : globals.FocusedForeground,
              size: iconSize
            )
          )
        )
      )
    );
  }
}