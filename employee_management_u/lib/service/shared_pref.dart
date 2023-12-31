import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferencesHelper? _instance;
  static SharedPreferences? _preferences;

  // Private constructor to ensure a singleton instance
  SharedPreferencesHelper._();

  //
  String token = "token";

  // Singleton pattern to get a single instance of SharedPreferencesHelper
  static Future<SharedPreferencesHelper> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferencesHelper._();
      await _instance!._init();
    }
    return _instance!;
  }

  // Initialize SharedPreferences
  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Get a value from SharedPreferences
  dynamic getValue(String key) {
    return _preferences!.get(key);
  }

  //clear
  // Function to clear SharedPreferences
  Future<bool> clear() {
    return _preferences!.clear();
  }

  // Set a value in SharedPreferences
  Future<bool> setValue(String key, dynamic value) {
    if (value is int) {
      return _preferences!.setInt(key, value);
    } else if (value is double) {
      return _preferences!.setDouble(key, value);
    } else if (value is bool) {
      return _preferences!.setBool(key, value);
    } else if (value is String) {
      return _preferences!.setString(key, value);
    } else {
      throw Exception("Unsupported value type");
    }
  }

  // Remove a value from SharedPreferences
  Future<bool> removeValue(String key) {
    return _preferences!.remove(key);
  }
}
