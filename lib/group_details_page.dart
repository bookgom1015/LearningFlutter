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

  final double _maxHeight = 200;
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

    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(navTitle: _receivedData['title']),
        body: Container(
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              height: deviceHeight,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: deviceWidth,
                        height: _currHeight,
                        child: FittedBox(
                          fit: BoxFit.none,
                          clipBehavior: Clip.hardEdge,
                          child: descBox(deviceWidth, 200)
                        )
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Column(
                          children: [
                            GestureDetector(
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
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: globals.IdentityColorLighter30
                                ),
                              )
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: globals.IdentityColor,
                                  borderRadius: globals.DefaultRadius
                                ),
                              )
                            )
                          ],
                        )
                      )
                    ],
                  );
                }
              )
            )
          )
        )
      )
    );
  }

  Widget descBox(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
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
                        tag: "group_post_" + _receivedData['index'].toString(),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(_receivedData['image']),
                            )                              
                          )
                        )
                      ),
                      Text(
                        _receivedData['host'],
                        style: const TextStyle(
                          color: globals.FocusedForeground
                        ),
                      )
                    ],
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
                    icon: const Icon(Icons.call),
                    color: globals.FocusedForeground,
                  ),
                ),
                SizedBox(
                  height: 45,
                  child: IconButton(
                    onPressed: () {}, 
                    icon: const Icon(Icons.message),
                    color: globals.FocusedForeground,
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
              ]
            ),
          )
        ],
      ),
    );
  }
}