
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/entries/user.dart';

class Post {
  int id;
  String title;
  List<String> tags;
  String desc;
  Group group;
  User user;

  Post({
    required this.id, 
    required this.desc, 
    required this.tags, 
    required this.title,
    required this.group,
    required this.user});

  Post.fromJson(dynamic json)
    : id = json["post"]["id"],
      title = json["post"]["title"],
      tags = List<String>.from(json["post"]["tags"].map((j) => j.toString())),
      desc = json["post"]["description"] ?? "",
      group = Group.fromJson(json["team"]),
      user = User.fromJson(json["user"]);
}