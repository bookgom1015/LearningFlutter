import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/entries/app_bar_btn.dart';
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
import 'dart:math' as math;

class WritePostPage extends StatefulWidget {
  static const double MaxHeight = 140;

  const WritePostPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WritePostPageState();
}

class _WritePostPageState extends State<WritePostPage> with SingleTickerProviderStateMixin {
  Map _receivedData = {};

  late KeyValueStorage _storage;

  String _title = "";
  String _tags = "";
  String _desc = "";

  late double _middleHeight;
  late double _currHeight;
  double _refHeight = 0;
  double _targetHeight = 0;
  double _prevY = 0;

  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _animation;

  late User _user;
  late Group _group;

  bool _collapsed = false;
  bool _sending = false;

  late double _deviceWidth;

  @override
  void initState() {
    super.initState();
    
    _middleHeight = WritePostPage.MaxHeight * 0.5;
    _currHeight = WritePostPage.MaxHeight;

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
        else if (_currHeight == WritePostPage.MaxHeight) {
          _collapsed = false;
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _deviceWidth = MediaQuery.of(context).size.width;

    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    _storage = _receivedData["storage"];
    _user = _receivedData["user"];
    _group = Group.fromJson(jsonDecode(_storage.get("group")));
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  void onSendButtonClicked() async {
    int statusCode = await writePost(
      _group.id,
      _tags, 
      _user.token, 
      _title, 
      _desc
    );
    _sending = false;
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(        
        appBar: createAppBar(
          height: globals.AppBarHeight,
          title: "?????????",
          backgroundColor: globals.AppBarColor,
          btnSize: 32,
          btnList: [
            AppBarBtn(
              icon: Icons.send,
              color: Colors.black,
              func: () {
                if (!_sending) {
                  _sending = true;   
                  onSendButtonClicked();
                }
              }
            )
          ]
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, _) {
                  return SizedBox(
                    height: _currHeight,
                    child: FittedBox(
                      fit: BoxFit.none,
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: _deviceWidth,
                        height: WritePostPage.MaxHeight,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            titleWidget(),
                            tagsWidget()
                          ],
                        )
                      )
                    )
                  );
                }
              ),
              gestureBarWidget(),
              const SizedBox(height: 5),
              descWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget titleWidget() {
    return Container(
      height: 60,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: TextFormField(
        style: const TextStyle(
          color: globals.FocusedForeground
        ),
        maxLines: 1,
        inputFormatters: [
          LengthLimitingTextInputFormatter(256)
        ],
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          hintText: "??????",
          hintStyle: TextStyle(
            color: globals.UnfocusedForeground
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: globals.UnderlineColor,
              width: 1
            )
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: globals.UnderlineColor,
              width: 1
            )
          ),
        ),
        onChanged: (text) {
           setState(() {
             _title = text;
           });
        },
      )
    );
  }

  Widget tagsWidget() {
    return Container(
      height: 60,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: TextFormField(
        style: const TextStyle(
          color: globals.FocusedForeground
        ),
        maxLines: 1,
        inputFormatters: [
          LengthLimitingTextInputFormatter(256)
        ],
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          hintText: "?????? (ex: tag1, tag2, tag3, ...)",
          hintStyle: TextStyle(
            color: globals.UnfocusedForeground
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: globals.UnderlineColor,
              width: 1
            )
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: globals.UnderlineColor,
              width: 1
            )
          )
        ),
        onChanged: (text) {
           setState(() {
             _tags = text;
           });
        },
      )
    );
  }

  Widget gestureBarWidget() {
    return GestureDetector(
      onVerticalDragStart: (details) {
        _prevY = details.globalPosition.dy;
        _refHeight = _currHeight;
      },
      onVerticalDragUpdate: (details) {
        double _deltaY = _prevY - details.globalPosition.dy;
        setState(() {
          _currHeight = math.min(math.max(_refHeight - _deltaY, 0), WritePostPage.MaxHeight);
        });
      },
      onVerticalDragEnd: (details) {
        _refHeight = _currHeight;
        double dy = details.velocity.pixelsPerSecond.dy;
        double abs_dy = dy;
        if (abs_dy < 0) abs_dy *= -1;
        if (abs_dy > globals.GestureBarTriggerSpeed) {
          if (dy > 0) {
            _targetHeight = WritePostPage.MaxHeight;
          }
          else {
            _targetHeight = 0;
          }
        }
        else {
          if (_currHeight > _middleHeight) {
            _targetHeight = WritePostPage.MaxHeight;
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
        height: 30,
        decoration: const BoxDecoration(
          color: Colors.transparent
        ),
        child: Icon(_collapsed ? Icons.keyboard_double_arrow_down : Icons.keyboard_double_arrow_up),
      )
    );
  }

  Widget descWidget() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(
            top: BorderSide(
              width: 1,
              color: globals.UnderlineColor,
            )
          )
        ),
        child: TextFormField(
          maxLines: null,
          style: const TextStyle(
            color: globals.FocusedForeground
          ),
          decoration: const InputDecoration(
            hintText: "????????? ???????????????",
            hintStyle: TextStyle(
              color: globals.UnfocusedForeground
            ),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none
          ),
          onChanged: (text) {
             setState(() {
               _desc = text;
             });
          }
        )
      )
    );
  }
}