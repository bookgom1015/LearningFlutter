import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/tag_list.dart';
import 'package:flutter_application_learning/entries/post.dart';
import 'package:flutter_application_learning/components/search_bar.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class GroupListPage extends StatefulWidget {
  final bool isPrivate;
  final User user;
  final BuildContext context;
  final PageController pageController;

  const GroupListPage({
    Key? key,
    required this.isPrivate,
    required this.user,
    required this.context, 
    required this.pageController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupListPageState();  
}

class _GroupListPageState extends State<GroupListPage> {
  final List<Post> _postList = [
    Post("Host 1", "assets/images/creeper_128x128.jpg", "Title 1", 
      "당신은 모르실거야 얼마나 사랑했는지 세월이 흘러가면은 그때서 미워질거야 마음이 서글플때나 초라해 보일때에는 이름을 불러주세요 나 거기 서 있을께요 워어어~~ 워어어 두눈에 넘쳐흐르는 뜨거운 나의 눈물로 당신의 아픈마음을 깨끗이 씻어드릴께 당신은 모르실거야 얼마나 사랑했는지 뒤돌아보아주세요 당신의 사랑있나요 두눈에 넘쳐흐르는 뜨거운 나의 눈물로 당신의 아픈마음을 깨끗이 씻어드릴께 당신은 모르실거야 얼마나 사랑했는지 뒤돌아보아주세요 당신의 사랑있나요 뒤돌아보아주세요 당신의사랑있나요 당신의사랑있나요당신의사랑있나요 당",
      ["C"]),
    Post("Host 2", "assets/images/creeper_128x128.jpg", "Title 2",
      "저녁이 되면 의무감으로 전화를 하고 관심도 없는 서로의 일과를 묻고는 하지 가끔씩은 사랑한단 말로 서로에게 위로하겠지만 그런 것도 예전에 가졌던 두근거림은 아니야 처음에 만난 그 느낌 그 설렘을 찾는다면 우리가 느낀 싫증은 이젠 없을 거야 주말이 되면 습관적으로 약속을 하고 서로를 위해 봉사한다고 생각을 하지 가끔씩은 서로의 눈 피해 다른 사람 만나기도 하고 자연스레 이별할 핑계를 찾으려 할 때도 있지 처음에 만난 그 느낌 그 설렘을 찾는다면 우리가 느낀 싫증은 이젠 없을 거야 처음에 만난 그 느낌",
      ["C", "C++"]),
    Post("Host 3", "assets/images/creeper_128x128.jpg", "Title 3",
      "늦여름 밤 바람 타고 불어오는 맘 어쩐지 딱 떠오르는 니 얼굴 깊어진 맘 달을 가려 잠을 설쳤어 난 오늘도 밤새 맘을 태웠어 So I and fly high 너의 창에 내려앉아 니 맘을 And knock knock 오늘은 두드릴 거야 새벽을 달려 어둠을 뚫고 Like you Like you 난 말할 거야 깊어진 밤 하늘 위로 차오르는 맘 그때쯤 딱 떠오르는 니 얼굴 깊어진 맘 별빛처럼 빛이 나나 봐 넌 오늘도 밤새 맘을 비췄어 So I and fly high 너의 창에 내려앉아",
      ["C#"]),
    Post("Host 4", "assets/images/creeper_128x128.jpg", "Title 4",
      "하루에 거울에 내 얼굴 바라보기에 슬프게 기쁘게 몇가지 표정지어봐도 웃는 나 우는 나 화내는 표정지으나 감출 수 없는 걸 언제나 나는 나니까 나는 노래할래요 모든 사람들에게 이 세상이 너무 넓어서 내 말 들어줄까요 저기서 여기까지 오늘날까지 먼 훗날까지 그날까지 풀 수 없는 몇가지 살아오며 겪어왔던 수많은 경험까지 내인생의 얽혀버린 수많은 인맥가지 우하 그 누구도 함부로 단정질 수 없는 일 나의 길 내가 누구이길 바래 세상에 하나뿐인 나는 나일뿐 내게 짧지 않은 5년이란 시간이란 내 몸속 저",
      ["JAVA", "Spring"]),
    Post("Host 5", "assets/images/creeper_128x128.jpg", "Title 5",
      "Ye how many people love you OK right 혼자 있어도 즐거운 둘이 있으면 신나는 평생을 이런대도 행복할거 같아 나만의 연인 yes give me a beat 날 기다리던 그 모습이 나 좋아 일부러 못본 척도 또 하곤 하고 내게 말하던 그 목소리가 좋아 일부러 못들은 척도 하곤 하고 첨엔 몰랐을땐 이게 사랑인가 무슨 감정인가 살아오며 난생 처음 무엇인가 두근 설레이며 오다보니 어디인가 무작정 행복한건 뭔가 알수없이 웃게 되는 이윤 뭔가 알면서도 모르는척 이게 사랑",
      ["GO", "COBOL"]),
    Post("Host 6", "assets/images/creeper_128x128.jpg", "Title 6",
      "She found a taste for different planets And other milkshake straw based habits It's over like october halloween Any wonder She's got a heart like rock hard granite Captured inside is a good girl When she's sober Like I know her To be Strawberry lips She takes a lot of trips There's never",
      ["Ruby", "Swift"]),
    Post("Host 7", "assets/images/creeper_128x128.jpg", "Title 7",
      "Girl 말해줘 네 마음 바로 지금 Baby 같이 올라가자 하늘 위로 All I wanna do is kick it with you 너의 몸매 그린 것만 같아 미술 오늘 의상처럼 네 마음도 씨쓰루 All I wanna do is kick it with you Girl 뭐가 중요한지 baby 바로 말해줄게 나 지금 5천만원짜리 시계 찼지만 나는 너를 훨씬 아끼지 babe 네가 원한다면 안 찰게 허세 따위는 안 통하니까 넌 정말 신기한 여자 나를 노력하게 만드니까 baby oh yeah 우리 둘의 밤을 상상했",
      ["R", "ML", "F#"]),
    Post("Host 8", "assets/images/creeper_128x128.jpg", "Title 8",
      "아무 말도 하려 하지 않아 오늘밤은 감은 눈을 뜨려 하지 않아 오늘밤은 사람들은 아주 가끔 착각 속에 실망을 들고 오니까 Call Me Now 아무 일도 없었던 것처럼 Call Me Now 아직 니가 난 너무 그리운데 지쳐 버린 날을 우린 다시 마주하고 눈물 대신 웃을 우린 절대 없을 테죠 사람들은 아주 가끔 떠오르는 누군가를 기대하니까 Call Me Now 아무 일도 없었던 것처럼 Call Me Now 아직 니가 난 너무 그리운데 다른 시간을 마주하는 게 아무렇지 않다 말을",
      ["Assembly"]),
    Post("Host 9", "assets/images/creeper_128x128.jpg", "Title 9",
      "저녁이되면 의무감으로 전화를하고 관심도 없는 서로의 일과를 묻곤하지 가끔씩은 사랑한단 말론 서로에게 위로하겠지만 그런것도 예전에 가졌던 두근거림은 아니야 처음에 만난 그느낌 그설레임을 찾는다면 우리가 느낀 싫증은 이젠 없을거야 이야아 주말이 되면 습관적으로 약속을하고 서로를 위해 봉사한다고 생각을 하지 가끔씩은 서로의 눈 피해 다른사람 만나기도 하고 자연스레 이별할 기회를 찾으려 할때도있지 처음에 만난 그느낌 그설레임을 찾는다면 우리가 느낀 싫증은 이젠 없을거야 이야아 처음에 만난 그느낌 그설레임을 찾는",
      ["DirectX", "OpenGL", "Vulkan", "Metal"]),
    Post("Host 10", "assets/images/creeper_128x128.jpg", "Title 10",
      "I am a poet in new york city You can see your face in my shoes I'm young and I'm alive I've got nothing to lose A dream a broken lie a kiss So much to resist And then I find you I am fire you are water Nothing we can do I walk into the room and light your fuse Love is revolution War and f",
      ["OpenCL", "Python"]),
    Post("Host 11", "assets/images/creeper_128x128.jpg", "Title 11",
      "Chorus:i've got the stuff that you wanti've got the thing that you needI got more than enoughTo make you drop to your kneesCuz I'm the queen of the nightQueen of the night oh yeah oh yeah oh yeah yeahDon't make no differenceIf I'm wrong or I'm rightI've got the feelingThat I'm willing tonightWell I",
      ["HTML", "CSS", "JS"]),
    Post("Host 12", "assets/images/creeper_128x128.jpg", "Title 12",
      "그대와 나의 사랑은 너무나 강렬하고도 애절했으며 그리고 위험했다 그것은 마치 서로에게 다가설수록 상처를 입히는 선인장과도 같은 다시 태어난다면 다시 사랑한다면 그때는 우리 이러지 말아요 조금 덜 만나고 조금 덜 기대하며 많은 약속 않기로 해요 다시 이별이 와도 서로 큰 아픔 없이 돌아설 수 있을 만큼 버려도 되는 가벼운 추억만 서로의 가슴에 만들기로 해요 이젠 알아요 너무 깊은 사랑은 외려 슬픈 마지막을 가져온다는 걸 그대여 빌게요 다음번에 사랑은 우리 같지 않길 부디 아픔이 없이 많은 시간이 흘러 서",
      ["Dart", "Flutter"]),
    Post("Host 13", "assets/images/creeper_128x128.jpg", "Title 13",
      "행복을 포기한채 돈버는게기쁨일까타인에 의해 랩하는게 진짜리듬인가믿음인양 죄를 덮어감싸주는게 벗우리가 쉽게 말하는진짜 친구일까이쁘니까? 아니면조금 쉬우니까사랑없이도 함께하는값진 이유인가livin a life is crazymaybe or m.ehelp me tell me누가 미쳤을까대화로 풀려버릴 고민의 끈대화가 두려워 바보처럼늘 고민해 끙평화는 고인의 꿈 절대안보이네 끝은이미 시작과 동시에날아가버린 축제니가 웃네 내가 울때니가 줄때 또 내가 줍네굳게 맘을먹어도 배고파행복과 시간은 늘 날 빼고가만약 내가 내일 죽는 다면누가 눈물 흘릴",
      ["JAVA", "Kotlin"]),
    Post("Host 14", "assets/images/creeper_128x128.jpg", "Title 14",
      "ONE 명탐정 코난 극장판 3기 OST / B'z - 세기말의 마술사 しずか すぎる よるだ みみが うずくほど 시즈카 스기루 요루다 미미가 우즈쿠호도 너무나 고요한 밤이야. 귀가 쑤실 정도로 ぼくも きみも だれも ねむって なん かいないのに 보쿠모 키미모 다레모 네 뭇 테 난 카이나이노니 나도 너도 그 누구도 잠들어 있다던가 하는 것도 아닌데… ことばがまだ たい せつなこと 코토바가마다 타이 세츠나코토 말이 아직 소중한 것들을 つたえ られるなら また なんでもいいから こえを きかせてよ",
      ["Android", "Mac", "IOS", "Windows", "Linux", "ABCDEFGHIJK"]),
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

  @override
  void dispose() {
    super.dispose();
    _searchBarFocusNode.dispose();
    _searchBarController.dispose();
  }

  // ignore: non_constant_identifier_names
  void SearchBarLostedFocus() {
    _searchBarFocusNode.unfocus();
    _searchBarController.clear();
  }

  @override
  Widget build(BuildContext context) {
    const double margin = 5;
    const double padding = 15;
    const double innerPadding = 10;

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double actualWidth = deviceWidth - padding - padding - innerPadding - innerPadding;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(padding, 10, padding, 0),
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
              child: groupListView(
                height: 190,
                titleHeight: 40,
                titleFontSize: 18,
                descHeight: 70,
                maxLines: 3,
                tagsWidth: actualWidth,
                tagsHeight: 20, 
                imageSize: 40,
                margin: margin, 
                padding: innerPadding
              )
            )
          ],
        ),
      ),
    );
  }

  Widget groupListView({
      required double height,
      required double titleHeight,
      required double titleFontSize,
      required double descHeight,
      required int maxLines,
      required double tagsWidth, 
      required double tagsHeight,
      required double imageSize,
      required double margin,
      required double padding}) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: globals.ListViewBottomPadding),
      itemCount: _postList.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () {
            if(_searchBarFocusNode.hasFocus) {
              SearchBarLostedFocus();
            }
            Navigator.pushNamed(
              widget.context, "/group_details", 
              arguments: { 
                "user": widget.user,
                "isPrivate": widget.isPrivate,
                "index": index,                          
                "title": _postList[index].title,
                "host": _postList[index].host,
                "image": _postList[index].image,
                "desc": _postList[index].desc
              }
            );
          },
          child: Container(
            height: height,
            margin: EdgeInsets.fromLTRB(0, margin, 0, margin),
            decoration: BoxDecoration(
              color: globals.IdentityColor,
              borderRadius: globals.DefaultRadius
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  TagList(width: tagsWidth, height: tagsHeight, tagList: _postList[index].tags),
                  // Title
                  SizedBox(
                    height: titleHeight,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _postList[index].title,
                        style: TextStyle(
                          color: globals.FocusedForeground,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    )
                  ),
                  // Descriptors
                  SizedBox(
                    height: descHeight,
                    child: Text(
                      _postList[index].desc,
                      maxLines: maxLines,
                      style: const TextStyle(
                        color: globals.FocusedForeground,
                        overflow: TextOverflow.ellipsis
                      ),
                    )
                  ),
                  // Image and host
                  Row(
                    children: [
                      Hero(
                        tag: (widget.isPrivate ? "private_" : "public_") + index.toString(),
                        child: Container(
                          width: imageSize,
                          height: imageSize,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage(_postList[index].image))
                          ),
                        )
                      ),
                      Text(
                        _postList[index].host,
                        style: const TextStyle(
                          color: globals.FocusedForeground
                        ),
                      )
                    ],
                  )
                ],                        
              )
            ),
          )
        );
      },
    );
  }
}