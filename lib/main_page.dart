import 'package:flutter/material.dart';
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

  final List<IconData> _icons = [
    Icons.list,
    Icons.group,
    Icons.manage_accounts
  ];

  @override
  void initState() {
    _pageController = PageController();
    _title = _titleList[0];
    
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
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
                bottomNavigationBar: bottomNavBar(
                  model: model,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0)
                ),
                body: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) { 
                    if (!model.isTapped) {
                      setState(() {
                        _title = _titleList[index];
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
              );
            }
          )
        ),
      )
    );
  }

  Widget bottomNavBar({
      required TabButtonModel model,
      EdgeInsets margin = EdgeInsets.zero,
      EdgeInsets padding = EdgeInsets.zero}) {

    return SizedBox(
      height: globals.NavBarHeight + margin.bottom,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: globals.IdentityColor,          
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [          
            BoxShadow(
              color: globals.ShadowColor,
              spreadRadius: 4,
              blurRadius: 8,
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
                  callback: () {
                    if (model.index == index) {
                      return;
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
    );
  }
}