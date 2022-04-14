import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/public.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class PublicPage extends StatefulWidget {
  const PublicPage({Key? key}) : super(key: key);

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

  FocusNode _focusNode = FocusNode();
  bool searchBarFocused = false;

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {
        searchBarFocused = _focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration: const BoxDecoration(
          color: globals.BackgroundColor
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: globals.UnfocusedForeground)
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: globals.FocusedForeground)
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: searchBarFocused ?globals.FocusedForeground : globals.UnfocusedForeground
                  )
                ),            
              )
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _publicList.length,
                itemBuilder: (_, index) {
                  return Container(
                    height: 64,
                    margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    decoration: BoxDecoration(
                      color: globals.IdentityColor,
                      borderRadius: globals.DefaultRadius
                    ),
                    child: GestureDetector(
                      onTap: () {},
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
                                    style: const TextStyle(
                                      color: globals.FocusedForeground
                                    ),
                                  )
                                ],
                              )
                            )
                          )
                        ],
                      ),
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