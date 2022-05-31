import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/add_button.dart';
import 'package:flutter_application_learning/components/alert_dialog.dart';
import 'package:flutter_application_learning/components/fade_out.dart';
import 'package:flutter_application_learning/components/heart_anim.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/loading.dart';
import 'package:flutter_application_learning/components/locked.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/post_list_view.dart';
import 'package:flutter_application_learning/components/star_anim.dart';
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/entries/join_request.dart';
import 'package:flutter_application_learning/entries/post.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
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

  late KeyValueStorage _storage;

  late User _user;
  late Subscriptions _subs;
  late Group _group;

  bool _blocked = true;
  bool _unqualified = false;

  List<Post> _posts = [];  

  bool _subsLoaded = false;
  bool _postsLoaded = false;

  late double _deviceWidth;
  late double _deviceHeight;

  bool _collapsed = false;
  bool _requesting = false;

  int _requestCount = 0;
  List<JoinRequest> _requests = [];

  @override
  void initState() {
    super.initState();

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
      if (!mounted) return;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height
                      - MediaQuery.of(context).padding.top // Status bar height
                      - AppBar().preferredSize.height;

    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    _storage = _receivedData["storage"];
    _group = _receivedData["group"];
    _user = User.fromJson(jsonDecode(_storage.get("user")));

    _storage.set("group", _group.toString());
    
    generateSubs();
    
    if (_user.id == _group.id) {
      generateJoinRequests();
    }
  }

  @override void dispose() {
    super.dispose();
    
    _controller.dispose();
  }

  void onJoinButtonClicked() async {
    int statusCode = await requestToJoin(
      _user.token, 
      _group.id
    );
    _requesting = false;
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
      return;
    }

    generateSubs();
    showAlertDialog(context: context, text: "참여 요청이 전송되었습니다.");
  }

  void qualify() {
    bool isMatched = false;
    for (var group in _subs.groups) {
      if (group.id == _group.id) {
        isMatched = true;
        _unqualified = false;
        break;
      }
    }
    
    setState(() {
      if (isMatched || !_group.type) {
      _blocked = false; 
      }
      if (!_blocked && !isMatched) {
        _unqualified = true;
      }
    });

    if (!_blocked) {
      generatePosts();   
    }
  }

  void generateGroup() async {
    int statusCode = await getGroupInfo(
      _group.id,
      (data) {
        setState(() {
          _group = data;
        });
        _storage.set("group", _group.toString());
      }
    );
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
      return;
    }
  }

  void generateSubs() async {
    int statusCode = await getSubscriptions(
      _user.id,
      (data) {
        _subs = data;
        _subsLoaded = true;
      }
    );
    _requesting = false;
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
      return;
    }

    qualify();
  }

  void generateJoinRequests() async {
    int statusCode = await getJoinRequests(
      _user.token,
      _group.id,
      (list) {
        _requests = list;
        setState(() {
          _requestCount = _requests.length;
        });
      }
    );
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
    }
  }

  void generatePosts() async {
    int statusCode = await getGroupPosts(
      _group.id, 
      (list) {
        if (mounted) {
          setState(() {
            _posts = list;
            _postsLoaded = true;
          });
        }  
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
                          topPanelWidget(),
                          const SizedBox(height: 10),
                          gestureBarWidget(_deviceWidth, 30),
                          postsWidget(_deviceWidth, 180)
                        ],
                      );
                    }
                  )
                )
              ),
              Positioned(
                bottom: 30,
                right: 30,
                child: createAddButton(
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
                        "storage": _storage,
                        "user": _user,
                      }
                    ).then((value) {
                      if (_user.id == _group.id) {
                        generateJoinRequests();
                      }
                    });
                  },
                  backgroundColors1: globals.AddPostButtonBackgroundColors1,
                  backgroundColors2: globals.AddPostButtonBackgroundColors2,
                  shadowColor: globals.ShadowColor,
                  disabled: _blocked
                )      
              )
            ]
          )
        )
      )
    );
  }

  Widget topPanelWidget() {
    return SizedBox(
      width: _deviceWidth,
      height: _currHeight,
      child: FittedBox(
        fit: BoxFit.none,
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            SizedBox(
              width: _deviceWidth,
              height: _maxHeight,
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
                                tag: "group_" + _receivedData['index'].toString(),
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
                                _group.hostName,
                                style: const TextStyle(
                                  color: globals.FocusedForeground,
                                  fontSize: 16
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _group.desc,
                                  maxLines: null,
                                  style: const TextStyle(
                                    color: globals.FocusedForeground,
                                  )
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
                          child: firstButtonWidget()
                        ),
                        const SizedBox(
                          height: 45,
                          child: StarAnim(
                            beginSize: 24,
                            endSize: 36,
                            fromColor: Colors.grey,
                            toColor: Colors.yellow,
                            stroke: 8,
                            storkeFromColor: Colors.grey,
                            storkeToColor: Color.fromARGB(255, 235, 133, 0)
                          )
                        ),
                        const SizedBox(
                          height: 45,
                          child: HeartAnim(
                            beginSize: 24, 
                            endSize: 36,
                            fromColor: Colors.grey,
                            toColor: Color.fromARGB(255, 255, 209, 230),
                            stroke: 8,
                            storkeFromColor: Colors.grey,
                            storkeToColor: Colors.red,
                          )
                        ),
                        SizedBox(
                          height: 45,
                          child: IconButton(
                            onPressed: () {}, 
                            icon: const Icon(Icons.report),
                            color: Colors.red,
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

  Widget firstButtonWidget() {
    bool isHost = _group.hostId == _user.id;
    if (!isHost) {
      return IconButton(
        onPressed: () {
          if (!_requesting) {
            _requesting = true;
            onJoinButtonClicked();
          }
        }, 
        icon: const Icon(
          Icons.notification_add,
          size: 28,
        ),
        color: Colors.green[300],
      );
    }

    List<Widget> widgetList = [];
    widgetList.add(
      IconButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/group_manage",
            arguments: {
              "storage": _storage,
              "requests": _requests,
              "user": _user
            }
          ).then((value) {
            generateGroup();

            if (_user.id == _group.id) {
              generateJoinRequests();
            }
          });
        },
        icon: const Icon(
          Icons.settings,
          size: 28,
        ),
        color: Colors.green[300],
      )
    );
    if (_requestCount > 0) {
      widgetList.add(
        Positioned(
          right: 5,
          bottom: 5,
          child: Container(
            width: 15,
            height: 15,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellow
            ),
            child: Center(
              child: Text(
                _requestCount.toString(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold
                ),
              )
            )
          )
        )
      );
    }

    return Stack(
      children: widgetList
    );
  }

  Widget gestureBarWidget(double width, double height) {      
    return GestureDetector(
      onVerticalDragStart: (details) {
        _prevY = details.globalPosition.dy;
        _refHeight = _currHeight;
      },
      onVerticalDragUpdate: (details) {
        if (!mounted) return;
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

  Widget postsWidget(double width, double height) {
    return Expanded(
      child: Stack(
        children: [          
          Container(
            child: !_subsLoaded ? loading() :
            _blocked ? locked(isPrivate: _group.type, fontColor: Colors.black) : 
            !_postsLoaded ? loading() :
            createPostListView(
              posts: _posts, 
              onTab: (index) {
                Navigator.pushNamed(
                  context, "/post",
                  arguments: {
                    "index": index,
                    "storage": _storage,
                    "post": _posts[index],
                  }
                ).then((value) {
                  if (_user.id == _group.id) {
                    generateJoinRequests();
                  }
                });
              }, 
              height: height, 
              titleHeight: 40, 
              imageSize: 40, 
              tagsWidth: width, 
              tagsHeight: 20,
              maxLines: 3,
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              padding: const EdgeInsets.all(10),
              viewItemPadding: const EdgeInsets.only(top: 20, bottom: 110),
              titleFontSize: 18
            )
          ),
          cretaeFadeOut(
            globals.BackgroundColor,
            const Color.fromARGB(0, 233, 232, 232)
          )
        ]
      )
    );
  }
}