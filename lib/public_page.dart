import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/public.dart';
import 'package:flutter_application_learning/components/search_bar.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class PublicPage extends StatefulWidget {
  final BuildContext context;
  final PageController pageController;

  const PublicPage({Key? key, required this.context, required this.pageController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PublicPageState();  
}

class _PublicPageState extends State<PublicPage> {
  final List<Public> _publicList = [
    Public("assets/images/creeper_128x128.jpg", "Title 1", "wefefwefj oifjwoi jwfowefw owef jwefjweofwe "),
    Public("assets/images/creeper_128x128.jpg", "Title 2", "wefijweoi jfjowewofjwefwe"),
    Public("assets/images/creeper_128x128.jpg", "Title 3", "xocivjsoi vw;eoklfm ejg oiwefgjw;ad"),
    Public("assets/images/creeper_128x128.jpg", "Title 4", "dfgoijrwepofgwjreojfjwe ejwowejfwejowejweof"),
    Public("assets/images/creeper_128x128.jpg", "Title 5", "wfgoiwjoosdjafaosdfj aoia jaopoj diof jsfjofjosdpfofjwaiwe"),
    Public("assets/images/creeper_128x128.jpg", "Title 6", "wefojfwejweofjwejiwe jwepwofw"),
    Public("assets/images/creeper_128x128.jpg", "Title 7", "fowifjweofjwewef"),
    Public("assets/images/creeper_128x128.jpg", "Title 8", "weofijwoeifjweof wefj wfowjwefwe pofwefwef"),
    Public("assets/images/creeper_128x128.jpg", "Title 9", "xcv,nwepfwjgoiejsdfj;owjfgweofj woflsdk fc"),
    Public("assets/images/creeper_128x128.jpg", "Title 10", "wefjsdfjlkwenmfwe owwfj oasjopi jwefwfwf "),
    Public("assets/images/creeper_128x128.jpg", "Title 11", "wfoijdfpoafjwoijfgwe jwfjwef jweopjwegjweofjwer jwefwewe"),
    Public("assets/images/creeper_128x128.jpg", "Title 12", "wefoijfwfjwfjpwe fjwifjwewefew"),
    Public("assets/images/creeper_128x128.jpg", "Title 13", "wfoijwweoifwee"),
    Public("assets/images/creeper_128x128.jpg", "Title 14", "ojcvlvcjroejwpejf fjawepofj ejwfwef"),
  ];

  final List<String> _dropDownMenuItemList = [
    "One", "Two", "Three", "Four"
  ];

  final FocusNode _searchBarFocusNode = FocusNode();
  final TextEditingController _searchBarController = TextEditingController();

  @override
  void initState() {
    widget.pageController.addListener(() {
      if(_searchBarFocusNode.hasFocus) {
        SearchBarLostedFocus();
      }
    });
    super.initState();
  }

  // ignore: non_constant_identifier_names
  void SearchBarLostedFocus() {
    _searchBarFocusNode.unfocus();
    _searchBarController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        decoration: const BoxDecoration(
          color: globals.BackgroundColor
        ),
        child: Column(
          children: [
            SearchBar(
              focusNode: _searchBarFocusNode,
              controller: _searchBarController,
              dropDownMenuItemList: _dropDownMenuItemList
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: _publicList.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      if(_searchBarFocusNode.hasFocus) {
                        SearchBarLostedFocus();
                      }
                      Navigator.pushNamed(widget.context, "/public_post", arguments: { "index": index });
                    },
                    child: Container(
                      height: 64,
                      margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      decoration: BoxDecoration(
                        color: globals.IdentityColor,
                        borderRadius: globals.DefaultRadius
                      ),
                      child: GestureDetector(
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),                
                                ),
                                image: DecorationImage(image: AssetImage(_publicList[index].image))
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _publicList[index].title,                                        
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,                                        
                                        color: globals.FocusedForeground
                                      ),
                                    ),
                                    Text(
                                      _publicList[index].desc,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: globals.FocusedForeground
                                      ),
                                    )
                                  ],
                                )
                              )
                            )
                          ],
                        )
                      )
                    )
                  );
                },
              )
            )
          ],
        ),
      ),
    );
  }
}