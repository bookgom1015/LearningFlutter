import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/entries/app_bar_btn.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/globals.dart' as globals;
import 'dart:math' as math;

class WritePostPage extends StatefulWidget {
  const WritePostPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WritePostPageState();
}

class _WritePostPageState extends State<WritePostPage> with SingleTickerProviderStateMixin {
  Map _receivedData = {};

  String _title = "";
  String _tags = "";
  String _desc = "";

  double _maxHeight = 140;
  final double _triggerVelocity = 250000; // Squared
  late double _middleHeight;
  late double _currHeight;
  double _refHeight = 0;
  double _targetHeight = 0;
  double _prevY = 0;

  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _animation;

  void send() {
    User user = _receivedData["user"];
    print(user.key);
  }

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
  Widget build(BuildContext context) {
    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    
    double deviceWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(        
        appBar: createAppBar(
          navTitle: "공개 글쓰기",
          btnSize: 32,
          btnList: [
            AppBarBtn(
              btnIcon: Icons.send,
              btnFunc: send
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
              titleAndTags(deviceWidth),
              GestureBar(),
              DescBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget titleAndTags(double width) {
    Widget titleWidget = Container(
      height: 60,
      margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: globals.IdentityColor,
        borderRadius: globals.DefaultRadius
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 40,
            child: Center(
              child: Text(
                "제목",
                style: TextStyle(
                  color: globals.FocusedForeground,
                  letterSpacing: 6
                )
              )
            )
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: const BoxDecoration(
                color: globals.IdentityColorDarker20,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
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
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none
                ),
                onChanged: (text) {
                   setState(() {
                     _title = text;
                   });
                },
              ),
            )
          )
        ],
      ),
    );

    Widget descWidget = Container(
      height: 60,
      margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: globals.IdentityColor,
        borderRadius: globals.DefaultRadius
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 40,
            child: Center(
              child: Text(
                "태그",
                style: TextStyle(
                  color: globals.FocusedForeground,
                  letterSpacing: 6
                )
              )
            )
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: const BoxDecoration(
                color: globals.IdentityColorDarker20,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
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
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none
                ),
                onChanged: (text) {
                   setState(() {
                     _tags = text;
                   });
                },
              ),                        
            )
          )
        ],
      )
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return SizedBox(
          height: _currHeight,
          child: FittedBox(
            fit: BoxFit.none,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: width,
              height: _maxHeight,
              child: Column(
                children: [
                  titleWidget,
                  descWidget
                ],
              )
            )
          )
        );
      }
    );
  }

  Widget GestureBar() {
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
        height: 15,
        margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: globals.IdentityColorLighter30
        ),
      )
    );
  }

  Widget DescBox() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
        decoration: BoxDecoration(
          color: globals.IdentityColor,
          borderRadius: globals.DefaultRadius
        ),
        child: Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: globals.IdentityColorDarker20,
            borderRadius: globals.DefaultRadius
          ),
          child: TextFormField(
            maxLines: null,
            style: const TextStyle(
              color: globals.FocusedForeground
            ),
            decoration: const InputDecoration(
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none
            ),
            onChanged: (text) {
               setState(() {
                 _desc = text;
               });
            },
          ),
        ),
      )
    );
  }
}