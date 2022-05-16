import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/nav_bar_clipper.dart';
import 'package:flutter_application_learning/components/title_anim.dart';
import 'package:flutter_application_learning/components/tab_btn_anim.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/group_list_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_learning/post_list_page.dart';
import 'package:flutter_application_learning/my_page.dart';
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

  final List<String> _titleList = ["공개글 목록", "팀 목록", "마이페이지"];
  late String _title;

  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _rotateAnimation;
  late Animation _colorAnimation;

  final List<IconData> _icons = [
    Icons.list,
    Icons.group,
    Icons.manage_accounts
  ];

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

    _controller.forward();
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

    User user = _receivedData["user"];
    Subscriptions subs = _receivedData["subs"];

    final List<Widget> pageList = [
      PostListPage(user: user, subs: subs, context: context, pageController: _pageController), 
      GroupListPage(user: user, subs: subs, context: context, pageController: _pageController), 
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
                      if (index != 1) {
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
                    return pageList[index];
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
    final double deviceWidth = MediaQuery.of(context).size.width;
    const double navBarBtnRadius = globals.NavBarBtnSize * 0.5;
    const double padding = 5;

    Widget navBar = Positioned(
      top: 30,
      child: Container(
        width: deviceWidth,
        height: globals.NavBarHeight,
        padding: const EdgeInsets.fromLTRB(padding, 0, padding, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [          
            BoxShadow(
              color: globals.ShadowColor,
              spreadRadius: 1,
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
                      padding: const EdgeInsets.fromLTRB(padding, 0, padding, 0),
                      child: TabButtonAnim(
                        model: model,
                        index: index,
                        callback: () {
                          if (model.index == index) {
                            return;
                          }
                          if (index != 1) {
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
                        },
                        icons: _icons
                      ),
                    );
                  }
                ),
              )
            )
          )
        )
      ),
    );

    Widget addGroupBtn = Positioned(
      top: 0,
      right: padding + globals.NavBarClipRight + (globals.NavBarClipSize - globals.NavBarBtnSize) * 0.5,
      child: GestureDetector(
        onTap: () {
          if (model.index != 2) {
            
          }                
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, _) {
            return Transform.rotate(
              angle: 45 * globals.DegToRad * _rotateAnimation.value,
              child: Container(         
                width: globals.NavBarBtnSize,
                height: globals.NavBarBtnSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: globals.IdentityColor,
                  boxShadow: [          
                    BoxShadow(
                      color: globals.ShadowColor,
                      spreadRadius: 1,
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
    );

    return SizedBox(
      height: globals.NavBarHeight + navBarBtnRadius + 10,
      child: Stack(
        children: [
          navBar,
          addGroupBtn
        ],
      )
    );
  }
}