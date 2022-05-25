
class UserProfile {
  int id;
  String fileName;
  int fileSize;
  String filePath;
  String desc;

  UserProfile({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.filePath,
    required this.desc});

  UserProfile.fromJson(dynamic json)
    : id = json["id"],
      fileName = json["fileName"] ?? "",
      fileSize = json["fileSize"],
      filePath = json["filePath"] ?? "assets/images/creeper_128x128.jpg",
      desc = json["description"] ?? "";

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write("{\"id\": "); sb.write(id);
    sb.write(", \"fileName\": \""); sb.write(fileName);
    sb.write("\", \"fileSize\": "); sb.write(fileSize);
    sb.write(", \"filePath\": \""); sb.write(filePath);
    sb.write("\", \"description\": \""); sb.write(desc);
    sb.write("\"}");
    return sb.toString();
  }
}