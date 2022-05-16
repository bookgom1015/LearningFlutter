import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/entries/post.dart';
import 'package:flutter_application_learning/entries/reply.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

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
        appBar: createAppBar(navTitle: _post.title),
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
                      child: ContentPartial(viewHeight)
                    )
                  ),
                  SizedBox(
                    height: _shrinkeddHeight + _heightAnimation.value * (extendedHeight - _shrinkeddHeight),
                    child: repliesPartial(deviceWidth)
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
  Widget ContentPartial(double viewHeight) {      
    return Container(
      margin: const EdgeInsets.all(10),
      constraints: BoxConstraints(
        minHeight: viewHeight - 20 // to exclude margin
      ),
      decoration: BoxDecoration(
        color: globals.IdentityColor,
        borderRadius: globals.DefaultRadius
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
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
                  decoration: BoxDecoration(
                    color: globals.IdentityColorLayer1,
                    borderRadius: globals.DefaultRadius
                  ),
                  child: Center(
                    child: Text(
                      _post.desc,
                      maxLines: null,
                      style: const TextStyle(
                        color: globals.FocusedForeground
                      ),
                    ),
                  ),
                ),                      
              ],
            )
          ],                  
        )
      ),
    );
  }

  Widget repliesPartial(double width) {
    return Container(
      decoration: const BoxDecoration(
        color: globals.IdentityColor,
        boxShadow: [
          BoxShadow(
            color: globals.ShadowColor,
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 0)
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
                  color: globals.IdentityColor,                                  
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
            child:  ListView.builder(
              itemCount: _replies.length,
              itemBuilder: (_, index) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                          decoration: BoxDecoration(
                            color: globals.IdentityColorLayer1,
                            borderRadius: globals.DefaultRadius                                    
                          ),
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
            )
          )
        ],
      ),
    );
  }
}