import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  final SharedPreferences prefs;
  AppStorage(this.prefs);
  static Future<AppStorage> create() async => AppStorage(await SharedPreferences.getInstance());
  bool? getBool(String k) => prefs.getBool(k);
  int? getInt(String k) => prefs.getInt(k);
  String? getString(String k) => prefs.getString(k);
  Future<void> setBool(String k, bool v) async => prefs.setBool(k, v);
  Future<void> setInt(String k, int v) async => prefs.setInt(k, v);
  Future<void> setString(String k, String v) async => prefs.setString(k, v);
}
