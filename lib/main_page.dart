import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/nav_bar_clipper.dart';
import 'package:flutter_application_learning/components/title_anim.dart';
import 'package:flutter_application_learning/components/tab_btn_anim.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_learning/group_list_page.dart';
import 'package:flutter_application_learning/my_page.dart';
import 'package:flutter_application_learning/post_page_list.dart';
import 'package:flutter_application_learning/entries/tab_btn_model.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();  
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  Map _receivedData = {};
  
  late PageController _pageController;

  final List<String> _titleList = ["Post List", "Group List", "My"];
  late String _title;

  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _rotateAnimation;
  late Animation _colorAnimation;
  @override
  void initState() {
    _pageController = PageController();
    _title = _titleList[0];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds:  globals.BasicAnimDuration)
    );

     _curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuart
    );

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 1
    ).animate(_curveAnimation);

     _colorAnimation = ColorTween(
      begin: globals.FocusedForeground,
      end: globals.UnfocusedForeground
    ).animate(_curveAnimation);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;

    final List<Widget> _pageList = [
      PostListPage(context: context, pageController: _pageController), 
      GroupListPage(context: context, pageController: _pageController), 
      const MyPage()
    ];

    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => TabButtonModel(),
        child: DefaultTabController(
          length: globals.TabSize,
          child: Consumer<TabButtonModel>(
            builder: (_, model, child) {
              return Scaffold(
                extendBody: true,
                appBar: AppBar(
                  backgroundColor: globals.IdentityColor,
                  elevation: 8,
                  title: TitleFadeInAnim(
                    title: _title,
                    model: model
                  ),
                ),
                bottomNavigationBar: bottomNavBar(context, model),
                body: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) { 
                    if (!model.isTapped) {
                      setState(() {
                        _title = _titleList[index];
                      });
                      model.updateIndex(index);
                      if (index == 2) {
                        _controller.forward();
                      }
                      else {
                        _controller.reverse();
                      }
                    }
                    if (model.index == index) {
                      model.isTapped = false;
                    }
                  },
                  itemCount: globals.TabSize,
                  itemBuilder: (_, index) {
                    return _pageList[index];
                  }
                ),
              );
            }
          )
        ),
      )
    );
  }

  Widget bottomNavBar(BuildContext context, TabButtonModel model) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double navBarBtnRadius = globals.NavBarBtnSize * 0.5;
    double padding = 5;

    return SizedBox(
      height: globals.NavBarHeight + navBarBtnRadius + 10,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            child: Container(
              width: deviceWidth,
              height: globals.NavBarHeight,
              padding: EdgeInsets.only(left: padding, right: padding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [          
                  BoxShadow(
                    color: globals.ShadowColor,
                    spreadRadius: 4,
                    blurRadius: 8,
                  )
                ]
              ),
              child: ClipPath(
                clipper: NavBarClipper(globals.NavBarClipSize * 0.5, globals.NavBarClipRight),
                child: Container(
                  decoration: BoxDecoration(
                    color: globals.IdentityColor,          
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: globals.NavBarClipSize),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        globals.TabSize,
                        (index) {                          
                          return Container(
                            padding: EdgeInsets.only(left: padding, right: padding),
                            child: TabButtonAnim(
                              model: model,
                              index: index,
                              callback: () {
                                if (model.index == index) {
                                  return;
                                }
                                if (index == 2) {
                                  _controller.forward();
                                }
                                else {
                                  _controller.reverse();
                                }
                                setState(() {
                                  _title = _titleList[index];
                                });
                                model.isTapped = true;
                                model.updateIndex(index);
                                _pageController.animateToPage(
                                  index, 
                                  duration: const Duration(
                                    milliseconds: globals.BasicAnimDuration
                                  ), 
                                  curve: Curves.easeInQuart,
                                );
                              }
                            ),
                          );
                        }
                      ),
                    )
                  )
                )
              )
            ),
          ),
          Positioned(
            top: 0,
            right: padding + globals.NavBarClipRight + (globals.NavBarClipSize - globals.NavBarBtnSize) * 0.5,
            child: GestureDetector(
              onTap: () {
                if (model.index == 0) {
                  Navigator.pushNamed(context, "/write_post", arguments: {"user": _receivedData["user"]});
                }
                else if (model.index == 1) {
                  Navigator.pushNamed(context, "/write_group_post");
                }
              },
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, _) {
                  return Transform.rotate(
                    angle: 0.785398 * _rotateAnimation.value,
                    child: Container(         
                      width: globals.NavBarBtnSize,
                      height: globals.NavBarBtnSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: globals.IdentityColor,
                        boxShadow: [          
                          BoxShadow(
                            color: globals.ShadowColor,
                            spreadRadius: 4,
                            blurRadius: 8,
                          )
                        ]
                      ),
                      child: Icon(
                        Icons.add,
                        color: _colorAnimation.value,
                        size: globals.NavBarBtnSize,
                      ),
                    )
                  );
                }
              )
            )
          )
        ],
      )
    );
  }
}