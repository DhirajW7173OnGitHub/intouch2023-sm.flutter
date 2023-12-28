import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static StorageUtil? _storageUtils;
  static SharedPreferences? _preferences;

  static Future<StorageUtil> getInstance() async {
    if (_storageUtils == null) {
      var secureStorage = StorageUtil._();
      await secureStorage._init();
      _storageUtils = secureStorage;
    }
    return _storageUtils!;
  }

  StorageUtil._();

  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  //get String
  static String getString(String key, {String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(key) ?? defValue;
  }

  //putString
  static Future<bool> putString(String key, String value) async {
    if (_preferences == null) return false;
    return _preferences!.setString(key, value);
  }

  //getBool
  static bool getBool(String key, {bool defValue = false}) {
    if (_preferences == null) return defValue;
    return _preferences!.getBool(key) ?? defValue;
  }

  //put bool
  static Future<bool> putBool(String key, bool value) async {
    if (_preferences == null) return false;
    return _preferences!.setBool(key, value);
  }

  //clear String
  static Future<bool> clearAll() async {
    if (_preferences == null) return false;
    return await _preferences!.clear();
  }
}
