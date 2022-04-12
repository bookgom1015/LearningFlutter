import 'package:flutter/material.dart';
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class ListPage extends StatefulWidget {
  final BuildContext context;

  const ListPage({Key? key, required this.context}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final List<Group> _groups = [
    Group("assets/images/creeper_128x128.jpg", "Title 1", "Host 1", ["C"]),
    Group("assets/images/creeper_128x128.jpg", "Title 2", "Host 2", ["C", "C++"]),
    Group("assets/images/creeper_128x128.jpg", "Title 3", "Host 3", ["C", "C++", "C#"]),
    Group("assets/images/creeper_128x128.jpg", "Title 5", "Host 5", ["Java", "Kotlin"]),
    Group("assets/images/creeper_128x128.jpg", "Title 6", "Host 6", ["Android"]),
    Group("assets/images/creeper_128x128.jpg", "Title 7", "Host 7", ["Android", "IOS"]),
    Group("assets/images/creeper_128x128.jpg", "Title 8", "Host 8", ["Windows", "Linux"]),
    Group("assets/images/creeper_128x128.jpg", "Title 9", "Host 9", ["Go", "Ruby", "R"]),
    Group("assets/images/creeper_128x128.jpg", "Title 10", "Host 10", ["OpenCL"]),
    Group("assets/images/creeper_128x128.jpg", "Title 11", "Host 11", ["OpenGL", "DirectX"]),
    Group("assets/images/creeper_128x128.jpg", "Title 12", "Host 12", ["Vulkan", "OpenGL"]),
    Group("assets/images/creeper_128x128.jpg", "Title 13", "Host 13", ["Skia, Direct2D"]),
  ];

  @override
  Widget build(BuildContext _) {
    return Scaffold(
      backgroundColor: globals.BackgroundColor,
      body: ListView.builder(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 70
        ),
        itemCount: _groups.length,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(widget.context, "/detail", arguments: { "index": index });
            },
            child: Container(
              height: 64,
              margin: const EdgeInsets.fromLTRB(15, 4, 15, 4),
              decoration: BoxDecoration(
                color: globals.IdentityColor,
                borderRadius: globals.defaultRadius
              ),
              child: Row(
                children: [
                  ImageBox(index),
                  PostDesc(index),
                ],
              )
            ),
          );
        },
      )
    );
  }

  // ignore: non_constant_identifier_names
  Widget ImageBox(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(tag: index.toString(), 
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
             ),
             image: DecorationImage(
               image: AssetImage(_groups[index].image)
             )
           )
         )
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget PostDesc(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(                        
          children: [
            const SizedBox(width: 15),
            Text(
              _groups[index].title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: globals.FocusedForeground
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _groups[index].host,
              style: const TextStyle(
                fontSize: 11,
                color: globals.FocusedForeground
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 15),
            Text(
              _groups[index].tags.join("  /  "),
              style: const TextStyle(
                color: globals.FocusedForeground
              ),
            )
          ],
        )
      ],
    );
  }
}