import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/title_anim.dart';
import 'package:flutter_application_learning/components/tab_btn_anim.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_learning/list_page.dart';
import 'package:flutter_application_learning/my_page.dart';
import 'package:flutter_application_learning/public_page.dart';
import 'package:flutter_application_learning/entries/tab_btn_model.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  final int tabSize = 3;

  @override
  State<StatefulWidget> createState() => _MainPageState();  
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late PageController _pageController;

  final List<String> _titleList = ["Open", "List", "MyPage"];
  late String _title;

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
    final List<Widget> _pageList = [
      const PublicPage(), 
      ListPage(context: context), 
      const MyPage()
    ];

    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => TabButtonModel(),
        child: DefaultTabController(
          length: widget.tabSize,
          child: Consumer<TabButtonModel>(
            builder: (context, model, child) {
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
                bottomNavigationBar: bottomNavBar(model),
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
                  itemCount: widget.tabSize,
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

  Widget bottomNavBar(TabButtonModel model) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 10),
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      decoration: BoxDecoration(
        color: globals.IdentityColor,
        boxShadow: const [          
          BoxShadow(
            color: globals.ShadowColor,
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(6, 4)
          )
        ],
        borderRadius: BorderRadius.circular(50)
      ),
      child: SizedBox(
        height: globals.BottomNavBarHeight,
        child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.tabSize,
              (index) {       
                return TabButtonAnim(
                  model: model,
                  index: index,
                  callback: () {
                    setState(() {
                      _title = _titleList[index];
                    });
                    model.isTapped = true;
                    model.updateIndex(index);
                    _pageController.animateToPage(
                      index, 
                      duration: const Duration(
                        milliseconds: globals.AnimDuration
                      ), 
                      curve: Curves.easeInQuart,
                    );
                  }
                );
              }
            ),
          )
        )
      ),
    );
  }
}