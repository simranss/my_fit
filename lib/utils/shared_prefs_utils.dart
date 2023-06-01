import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtils {
  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<bool?> getBool(String key) async {
    return (await _getPrefs()).getBool(key);
  }

  static Future<int?> getInt(String key) async {
    return (await _getPrefs()).getInt(key);
  }

  static Future<String?> getString(String key) async {
    return (await _getPrefs()).getString(key);
  }

  static Future<List<String>?> getStringList(String key) async {
    return (await _getPrefs()).getStringList(key);
  }

  static Future<double?> getDouble(String key) async {
    return (await _getPrefs()).getDouble(key);
  }

  static Future<void> setBool(String key, bool value) async {
    (await _getPrefs()).setBool(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    (await _getPrefs()).setInt(key, value);
  }

  static Future<void> setString(String key, String value) async {
    (await _getPrefs()).setString(key, value);
  }

  static Future<void> setStringList(String key, List<String> value) async {
    (await _getPrefs()).setStringList(key, value);
  }

  static Future<void> setDouble(String key, double value) async {
    (await _getPrefs()).setDouble(key, value);
  }

  static Future<void> remove(String key) async {
    (await _getPrefs()).remove(key);
  }
}
