
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorage {
  late SharedPreferences _prefs;

  void init() {
    var inst = SharedPreferences.getInstance();

    inst.then((value) {
      _prefs = value;
    });
  }

  void set(String key, String value) {
    _prefs.setString(key, value);
  }

  String get(String key) {
    return _prefs.getString(key) ?? "";
  }
}