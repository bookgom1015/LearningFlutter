import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/entries/reply.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class DetailPostPage extends StatefulWidget {
  const DetailPostPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> with SingleTickerProviderStateMixin {
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

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: globals.AnimDuration)
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
  Widget build(BuildContext context) {
    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;

    double deviceWidth = MediaQuery.of(context).size.width;
    double extendedHeight = MediaQuery.of(context).size.height * 0.5;

    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(_receivedData["title"]),
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
                    child: SizedBox(
                      child: SingleChildScrollView(
                        child: ContentPartial()
                      )
                    )
                  ),
                  SizedBox(
                    height: _shrinkeddHeight + _heightAnimation.value * (extendedHeight - _shrinkeddHeight),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: globals.IdentityColorDarker20,
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
                                  color: globals.IdentityColorDarker20,                                  
                                ),
                                width: deviceWidth,
                                height: 50,
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
                                            color: globals.IdentityColorLighter30,
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
                    ),
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
  Widget ContentPartial() {
    return Container(
      margin: const EdgeInsets.all(10),
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
                  tag: _receivedData['index'].toString(),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage(_receivedData['image']))
                    ),
                  )
                ),
                Text(
                  _receivedData['host'],
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
                  height: 600,
                  decoration: BoxDecoration(
                    color: globals.IdentityColorLighter50,
                    borderRadius: globals.DefaultRadius
                  ),
                  child: const Center(
                    child: Text(
                      "대충 글 써질 곳",
                      style: TextStyle(
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
}