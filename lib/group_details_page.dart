import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/heart_anim.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/star_anim.dart';
import 'package:flutter_application_learning/globals.dart' as globals;
import 'dart:math' as math;

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

  @override void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height - 
      MediaQuery.of(context).padding.top - // Status bar height
      AppBar().preferredSize.height;

    bool isPrivate = _receivedData["isPrivate"];

    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(navTitle: _receivedData['title']),
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
                            height: _maxHeight
                          ),
                          const SizedBox(height: 10),
                          gestureBar(
                            height: 40
                          ),
                          postList(
                            isPrivate: isPrivate
                          )
                        ],
                      );
                    }
                  )
                )
              ),
              addPostBtn(
                isPrivate: isPrivate, 
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
      required double height}) {
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
                                tag: (_receivedData["isPrivate"] ? "private_" : "public_") + _receivedData['index'].toString(),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(_receivedData['image']),
                                    )                              
                                  )
                                )
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _receivedData['host'],
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
                                _receivedData["desc"],
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
                margin: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: globals.IdentityColor,
                  borderRadius: globals.DefaultRadius
                ),
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
      required bool isPrivate}) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: globals.IdentityColor,
                borderRadius: globals.DefaultRadius
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_sharp,
                        color: globals.FocusedForeground,
                        size: isPrivate ? 64 : 0,
                      ),
                      Text(
                        "똥닌겐 따위에게 권한은 없는데스우",
                        style: TextStyle(
                          color: globals.FocusedForeground,
                          fontSize: isPrivate ? 18 : 0
                        )
                      )
                    ],
                  )
                ]
              )
            )
          )
        ],
      )
    );
  }

  Widget addPostBtn({
      required bool isPrivate,
      required double bottom,
      required double right,
      required double size,
      required double iconSize}) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: GestureDetector(
        onTap: () {
          if (isPrivate) return;          
          Navigator.pushNamed(
            context, "/write_post", 
            arguments: {
              "isPrivate": isPrivate,
              "user": _receivedData["user"]                    
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
            angle: isPrivate ? (45 * globals.DegToRad) : 0,
            child: Icon(
              Icons.add,
              color: isPrivate ? globals.UnfocusedForeground : globals.FocusedForeground,
              size: iconSize
            )
          )
        )
      )
    );
  }
}