import 'package:flutter_application_learning/entries/user.dart';

class Comment {
  int id;
  String desc;
  User user;

  Comment({
    required this.id,
    required this.desc,
    required this.user});

  Comment.fromJson(dynamic json)
    : id = json["id"],
      desc = json["description"],
      user = User.fromJson(json["user"]);

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write("{\"id\": "); sb.write(id);
    sb.write(", \"description\": \""); sb.write(desc);
    sb.write("\", \"user\": "); sb.write(user.toString());
    sb.write("}");
    return sb.toString();
  }
}