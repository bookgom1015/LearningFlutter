import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/Router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return createRouter();
  }
}

/*
[ User ]
1-1 o
1-2 o
1-3 o
1-4 o
1-5 o
1-6 o
1-7 o

[ Team ]
2-1 o
2-2 o
2-3 o
2-4 ? - 공개팀은 정상작동하나 비공개팀은 오류
2-5 o
2-6 x - 참가 요청 수락
2-7 x -     "    거절
2-8 o
2-9 o

[ Post ]
3-1 o
3-2 o
3-3 o
3-4 x - 특정 글 읽기
3-5 o 
3-6 o 
3-7 o
3-8 x - 팀 글 검색
3-9 x - 유저 글 검색
 */