import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/pepe.dart';
import 'package:flutter_application_learning/components/title_anim.dart';
import 'package:flutter_application_learning/components/tab_btn_anim.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/group_list_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_learning/post_list_page.dart';
import 'package:flutter_application_learning/my_page.dart';
import 'package:flutter_application_learning/entries/tab_btn_model.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;

class MainPage extends StatefulWidget {
  static const double TabButtonMaxSize = 52;
  static const double TabButtonMinSize = 36;
  static const double TabButtonIconMaxSize = 36;
  static const double TabButtonIconMinSize = 24;

  static const List<IconData> TabButtonIcons = [
    Icons.list,
    Icons.group,
    Icons.manage_accounts
  ];

  static const List<String> TitleList = ["공개글 목록", "팀 목록", "마이페이지"];

  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();  
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  Map _receivedData = {};
  
  late PageController _pageController;
  late String _title;

  bool _triggerd = false;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    
    _pageController = PageController();
    _title = MainPage.TitleList[0];
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;

    KeyValueStorage storage = _receivedData["storage"];

    User user = User.fromJson(jsonDecode(storage.get("user")));
    Subscriptions subs = Subscriptions.fromJson(jsonDecode(storage.get("subs")));

    final List<Widget> pageList = [
      PostListPage(storage: storage, context: context, pageController: _pageController), 
      GroupListPage(storage: storage, context: context, pageController: _pageController), 
      MyPage(storage: storage, context: context, pageController: _pageController)
    ];

    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => TabButtonModel(maxSize: MainPage.TabButtonMaxSize),
        child: DefaultTabController(
          length: globals.TabSize,
          child: Consumer<TabButtonModel>(
            builder: (_, model, child) {
              return Scaffold(
                extendBody: true,
                appBar: AppBar(
                  backgroundColor: globals.AppBarColor,
                  elevation: 0,
                  title: TitleFadeInAnim(
                    title: _title,
                    model: model
                  ),
                  toolbarHeight: globals.AppBarHeight,
                ),
                bottomNavigationBar: navBarWidget(
                  model: model,
                  height: 70,
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0)
                ),
                body: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) { 
                        if (!model.isTapped) {
                          setState(() {
                            _title = MainPage.TitleList[index];
                          });
                          model.updateIndex(index);
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
                    _triggerd ? const PepeRain() : const SizedBox()
                  ]
                )
              );
            }
          )
        ),
      )
    );
  }

  Widget navBarWidget({
      required TabButtonModel model,
      required double height,
      EdgeInsets margin = EdgeInsets.zero,
      EdgeInsets padding = EdgeInsets.zero}) {

    return SizedBox(
      height: height + margin.bottom,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height * 0.5),
          gradient: const RadialGradient(
            center: Alignment.center,
            radius: 3,      
            stops: [
              0.5,
              1.0
            ],      
            colors: [
              globals.NavBarColors1,
              globals.NavBarColors2,
            ]
          ),
          boxShadow: const [
            BoxShadow(
              color: globals.NavBarShadowColor,
              blurRadius: 16,
              spreadRadius: 1
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            globals.TabSize,
            (index) {                          
              return Container(
                padding: padding,
                child: TabButtonAnim(
                  model: model,
                  index: index,
                  minSize: MainPage.TabButtonMinSize,
                  maxSize: MainPage.TabButtonMaxSize,
                  minIconSize: MainPage.TabButtonIconMinSize,
                  maxIconSize: MainPage.TabButtonIconMaxSize,
                  fromColor: globals.TabButtonUnfocusedColor,
                  toColor: globals.TabButtonFocusedColor,
                  fromIconColor: globals.UnfocusedForeground,
                  toIconColor: globals.FocusedForeground,
                  animDuration: globals.BasicAnimDuration,
                  callback: () {
                    if (model.index == index) {
                      ++_count;
                      if (_count >= 13) {
                        _triggerd = true;
                      }
                      return;
                    }
                    setState(() {
                      _title = MainPage.TitleList[index];
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
                  icons: MainPage.TabButtonIcons
                ),
              );
            }
          ),
        )
      )
    );
  }
}