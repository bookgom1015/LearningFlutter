
class Group {
  final int id;
  final String name;
  final List<String> tags;
  final String desc;
  final String fileName;
  final int fileSize;
  final String filePath;
  final bool type;
  final int hostId;
  final String hostName;
  final bool closed;

  Group({
    required this.id,
    required this.name,
    required this.tags,
    required this.desc,
    required this.fileName,
    required this.fileSize,
    required this.filePath,
    required this.type,
    required this.hostId,
    required this.hostName,
    required this.closed});

  Group.fromJson(dynamic json) 
    : id = json["id"],
      name = json["name"],
      tags = json["tags"].cast<String>(),
      desc = json["description"] ?? "",
      fileName = json["fileName"] ?? "",
      fileSize = json["fileSize"],
      filePath = json["filePath"] ?? "assets/images/creeper_128x128.jpg",
      type = json["type"] == "PRIVATE",
      hostId = json["hostId"],
      hostName = json["hostName"],
      closed = json["closed"];

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write("{\"id\": "); sb.write(id);
    sb.write(", \"name\": \""); sb.write(name);
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
    sb.write("\", \"fileName\": \""); sb.write(fileName);
    sb.write("\", \"fileSize\": "); sb.write(fileSize);
    sb.write(", \"filePath\": \""); sb.write(filePath);
    sb.write("\", \"type\": \""); sb.write(type ? "PRIVATE" : "PUBLIC");
    sb.write("\", \"hostId\": "); sb.write(hostId);
    sb.write(", \"hostName\": \""); sb.write(hostName);
    sb.write("\", \"closed\": "); sb.write(closed.toString());
    sb.write("}");
    return sb.toString();
  }
}