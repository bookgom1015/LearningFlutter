import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as math;
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
                appBar: appBar(),
                bottomNavigationBar: bottomNavBar(model),
                body: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) { 
                    if (!model.isTapped) {
                      model.updateIndex(index);
                    }
                    model.isTapped = false;
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

  AppBar appBar() {
    return AppBar(
      backgroundColor: globals.IdentityColor,
      elevation: 8,
      title: Stack(
        children: <Widget>[
          Text(
            _title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = Colors.grey.shade600,
            ),
          ),
          Text(
            _title,
            style: const TextStyle( 
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ],
      ),     
    );
  }

  Widget bottomNavBar(TabButtonModel model) {
    const List<IconData> iconList = [
      Icons.comment_bank,
      Icons.list,
      Icons.manage_accounts
    ];

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
        height: globals.bottomNavBarHeight,
        child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.tabSize,
              (index) {                
                return AnimatedContainer(
                  margin: EdgeInsets.only(
                    left: model.animateMargin(index),
                    right: model.animateMargin(index),
                  ),
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.translation(
                    math.Vector3(
                      model.translateX(index),
                      0,
                      0)
                  ),
                  child: SizedBox(
                    width: globals.tabBoxSize,
                    height: globals.tabBoxSize,
                    child: Stack(
                      children: [
                        Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: model.animateSize(index),
                            height: model.animateSize(index),
                            decoration: BoxDecoration(
                              color: model.animateColor(
                                index,
                                globals.IdentityColorLighter70,
                                globals.IdentityColorLighter50),
                              shape: BoxShape.circle
                            )
                          ),
                        ),
                        Center( child: IconButton(
                          onPressed: () {
                            model.isTapped = true;
                            model.updateIndex(index);
                            _pageController.animateToPage(
                              index, 
                              duration: const Duration(milliseconds: 300), 
                              curve: Curves.easeInQuart,
                            );
                          },
                          icon: Icon(
                            iconList[index],
                            size: 32
                          ),
                          color: model.animateColor(
                            index,
                            globals.FocusedForeground,
                            globals.UnfocusedForeground),
                        ))
                      ]
                    ),
                  )
                );
              }
            ),
          )
        )
      ),
    );
  }
}