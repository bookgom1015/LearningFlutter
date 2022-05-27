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

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write("{\"id\": "); sb.write(id);
    sb.write(", \"title\": \""); sb.write(title);
    sb.write("\", \"tags\": [");
    StringBuffer tagSb = StringBuffer();
    for (String tag in tags) {
      tagSb.write("\"");
      tagSb.write(tag);
      tagSb.write("\"");
      tagSb.write(",");
    }
    String tagStr = tagSb.toString();
    if (tags.length > 0) {
      String tagSubstr = tagStr.substring(0, tagStr.length - 1);
      sb.write(tagSubstr);
    }
    sb.write("], \"description\": \""); sb.write(desc);
    sb.write("\", \"group\": "); sb.write(group.toString());
    sb.write(", \"user\": "); sb.write(user.toString());
    sb.write("}");
    return sb.toString();
  }
}