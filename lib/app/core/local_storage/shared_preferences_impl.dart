import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'i_local_storage.dart';

class SharedPreferencesImpl implements ILocalStorage {
  @override
  Future<dynamic> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.get(key);

    try {
      return jsonDecode(result as String);
    } catch (e) {
      return result;
    }
  }

  @override
  Future<bool> setData({required final String key, final dynamic value}) async {
    final prefs = await SharedPreferences.getInstance();
    switch (value.runtimeType.toString()) {
      case 'String':
        return await prefs.setString(key, value);
      case 'int':
        return await prefs.setInt(key, value);
      case 'bool':
        return await prefs.setBool(key, value);
      case 'double':
        return await prefs.setDouble(key, value);
      case 'List<String>':
        return await prefs.setStringList(key, value);
      default:
        return await prefs.setString(key, jsonEncode(value));
    }
  }

  @override
  Future<bool> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  @override
  Future<bool> clean() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
