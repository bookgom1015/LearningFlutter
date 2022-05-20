import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/alert_dialog.dart';
import 'package:flutter_application_learning/components/heart_anim.dart';
import 'package:flutter_application_learning/components/loading.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/post_list_view.dart';
import 'package:flutter_application_learning/components/star_anim.dart';
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/entries/post.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/globals.dart' as globals;
import 'dart:math' as math;
import 'package:http/http.dart' as http;

class GroupDetailsPage extends StatefulWidget {
  const GroupDetailsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupDetailsPageState();  
}

class _GroupDetailsPageState extends State<GroupDetailsPage> with SingleTickerProviderStateMixin {
  Map _receivedData = {};

  final double _maxHeight = 200;
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

  List<Post> _posts = [];

  bool _loaded = false;

  double _deviceWidth = 0;
  double _deviceHeight = 0;

  bool _collapsed = false;

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

        if (_currHeight == 0) {
          _collapsed = true;
        }
        else if (_currHeight == _maxHeight) {
          _collapsed = false;
        }
      });
    });
    super.initState();
  }

  void getPosts() async {
    StringBuffer uri = StringBuffer();
      uri.write(globals.SpringUriPath);
      uri.write("/api/team/");
      uri.write(_group.id);
      uri.write("/post");

      var response = await http.get(Uri.parse(uri.toString()));

      if (response.statusCode != 200) {
        print("error occured: " + response.statusCode.toString());
      }
      else {
        dynamic jsonArray = jsonDecode(response.body);
        
        List<Post> posts = [];
        for (var json in jsonArray) {
          posts.add(Post.fromJson(json));
        }
        
        setState(() {
          _posts = posts;
          _loaded = true;
        });
      }
  }

  @override
  void didChangeDependencies() {
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

    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height - 
      MediaQuery.of(context).padding.top - // Status bar height
      AppBar().preferredSize.height;

    super.didChangeDependencies();
  }

  @override void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_blocked) {
      getPosts();   
    }

    final double deviceWidth = MediaQuery.of(context).size.width;
    
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight,
          title: _group.name,
          backgroundColor: globals.AppBarColor
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: _deviceHeight,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          descriptionsAndButtonsWidget(
                            width: _deviceWidth, 
                            height: _maxHeight,
                            tag: "group_" + _receivedData['index'].toString()
                          ),
                          const SizedBox(height: 10),
                          gestureBarWidget(
                            width: deviceWidth,
                            height: 30
                          ),
                          postsWidget(
                            width: deviceWidth, 
                            height: 180
                          )
                        ],
                      );
                    }
                  )
                )
              ),
              addPostButtonWidget()
            ]
          )
        )
      )
    );
  }

  Widget descriptionsAndButtonsWidget({
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
              height: height,
              child: Row(
                children: [
                  // Descriptions
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      padding: const EdgeInsets.all(10),
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
                  // Buttons
                  Container(
                    width: 60,
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
          ]
        )
      )
    );
  }

  Widget gestureBarWidget({
      required double width,
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
        double dy = details.velocity.pixelsPerSecond.dy;
        double abs_dy = dy;
        if (abs_dy < 0) abs_dy *= -1;
        if (abs_dy > globals.GestureBarTriggerSpeed) {
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
        double speed = math.min(abs_dy, globals.GestureBarMaxSpeed);
        double coeiff = (globals.GestureBarMaxSpeed - speed) / globals.GestureBarMaxSpeed;
        int msec = math.max(globals.BasicAnimDuration * coeiff, 1).toInt();
        _controller.duration = Duration(milliseconds: msec);
        _controller.reset();
        _controller.forward();
      }, 
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          color: Colors.transparent
        ),
        child: Icon(_collapsed ? Icons.keyboard_double_arrow_down : Icons.keyboard_double_arrow_up)
      )
    );
  }

  Widget postsWidget({
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
      child: Stack(
        children: [          
          Container(
            child: _blocked ? lockWidget :
            _loaded ? createPostListView(
              posts: _posts, 
              onTab: (index) {
                Navigator.pushNamed(
                  context, "/post",
                  arguments: {
                    "index": index,
                    "post": _posts[index],
                  }
                );
              }, 
              height: height, 
              titleHeight: 40, 
              imageSize: 40, 
              tagsWidth: actualWidth, 
              tagsHeight: 20,
              maxLines: 3,
              margin: const EdgeInsets.fromLTRB(margin, 5, margin, 5),
              padding: const EdgeInsets.all(10),
              viewItemPadding: const EdgeInsets.only(top: 20, bottom: 110),
              titleFontSize: 18
            ) : loading()
          ),
          Container(
            width: width,
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
      )
    );
  }

  Widget addPostButtonWidget() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: GestureDetector(
        onTap: () {
          if (_blocked) return;          
          if (_unqualified) {
            showAlertDialog(
              context: context,
              text: "팀에 소속되어 있지 않습니다. \n글을 작성하시려면 먼저 팀에 가입해주세요.",
              fontColor: globals.FocusedForeground,
              backgroundColor: globals.DialogBackgroundColor,
              borderRadius: globals.DefaultRadius
            );
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
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              stops: [
                0.2,
                0.6
              ],
              colors: [
                globals.AddPostButtonBackgroundColors1,
                globals.AddPostButtonBackgroundColors2,
              ]
            ),
            boxShadow: [          
              BoxShadow(
                color: globals.ShadowColor,
                spreadRadius: 2,
                blurRadius: 16,
                offset: Offset(4, 4)
              ),
            ]
          ),
          child: Transform.rotate(
            angle: _blocked ? (45 * globals.DegToRad) : 0,
            child: Icon(
              Icons.add,
              color: _blocked ? globals.UnfocusedForeground : globals.FocusedForeground,
              size: 50
            )
          )
        )
      )
    );
  }
}