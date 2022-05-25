import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/entries/post.dart';
import 'package:flutter_application_learning/entries/reply.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with SingleTickerProviderStateMixin {
  Map _receivedData = {};

  final List<Reply> _replies = [
    Reply("assets/images/champi_1_256x256.jpg", "중실장", "아리갓또뎃즈웅"),
    Reply("assets/images/champi_2_256x256.jpg", "저실장", "붕쯔붕쯔"),
    Reply("assets/images/champi_3_256x256.jpg", "우지챠", "레후~"),
    Reply("assets/images/champi_1_256x256.jpg", "중실장", "아리갓또뎃즈웅"),
    Reply("assets/images/champi_2_256x256.jpg", "저실장", "붕쯔붕쯔"),
    Reply("assets/images/champi_3_256x256.jpg", "우지챠", "레후~"),
    Reply("assets/images/champi_1_256x256.jpg", "중실장", "아리갓또뎃즈웅"),
    Reply("assets/images/champi_2_256x256.jpg", "저실장", "붕쯔붕쯔"),
    Reply("assets/images/champi_3_256x256.jpg", "우지챠", "레후~"),
  ];

  final double _shrinkeddHeight = 50;
  bool isExtended = false;

  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _heightAnimation;

  late Post _post;

  @override
  void initState() {
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didChangeDependencies() {
    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;

    _post = _receivedData["post"];

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double extendedHeight = MediaQuery.of(context).size.height * 0.5;
    
    double viewHeight = MediaQuery.of(context).size.height - 
      MediaQuery.of(context).padding.top - // Status bar height
      AppBar().preferredSize.height - _shrinkeddHeight;

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
                      child: contentWidget(viewHeight)
                    )
                  ),
                  SizedBox(
                    height: _shrinkeddHeight + _heightAnimation.value * (extendedHeight - _shrinkeddHeight),
                    child: repliesWidget(deviceWidth)
                  )
                ]
              )
            );
          }
        )
      ),
    );
  }

  // ignore: non_constant_identifier_names
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
                  onTap: () {
                    setState(() {
                      isExtended = !isExtended;
                      if (isExtended) {
                        _controller.forward();
                      }
                      else {
                        _controller.reverse();
                      }
                    });
                  },
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
                ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: _replies.length,
                  itemBuilder: (_, index) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 12),
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
                            globals.RepliesListViewItemBackgroundColors1,
                            globals.RepliesListViewItemBackgroundColors2,
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
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  image: DecorationImage(
                                    image: AssetImage(_replies[index].image),
                                  )
                                )
                              ),
                              Text(
                                _replies[index].name,
                                style: const TextStyle(
                                  color: globals.FocusedForeground
                                )
                              )
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                              child: Text(
                                _replies[index].text,
                                style: const TextStyle(
                                  color: globals.FocusedForeground
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                    );
                  }
                ),
                Container(
                  width: width,
                  height: 30,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        globals.RepliesBackgroundColors2,
                        Color.fromARGB(0, 233, 232, 232),
                      ]
                    )
                  )
                )
              ],
            )
          )
        ],
      ),
    );
  }
}