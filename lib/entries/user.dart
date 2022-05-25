
import 'package:flutter_application_learning/entries/user_profile.dart';

class User {
  String token;
  int id;
  String userName;
  String userNickname;
  UserProfile userProfile;

  User({
    required this.token, 
    required this.id,
    required this.userName,
    required this.userNickname,
    required this.userProfile});

  User.fromJson(dynamic json)
    : token = json["token"] ?? "",
      id = json["id"],
      userName = json["userName"] ?? "",
      userNickname = json["userNickname"],
      userProfile = UserProfile.fromJson(json["userProfile"]);

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write("{\"token\": \""); sb.write(token);
    sb.write("\", \"id\": "); sb.write(id);
    sb.write(", \"userName\": \""); sb.write(userName);
    sb.write("\", \"userNickname\": \""); sb.write(userNickname);
    sb.write("\", \"userProfile\": "); sb.write(userProfile.toString());
    sb.write("}");
    return sb.toString();
  }
}