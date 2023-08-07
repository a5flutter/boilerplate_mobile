import 'package:blank_project/flavor/flavor_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalStorage {
  Future<String?> get(String key);

  Future save(String key, String data);

  Future remove(String key);
}


class LocalStorage extends ILocalStorage{

  @override
  Future<String?> get(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      return prefs.getString(key);
    }catch(e){
      devPrint('Error getting $key from local storage - $e');
      return null;
    }
  }

  @override
  Future save(String key, String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString(key, data);
    } catch (e) {
      devPrint('Error saving $key to local storage - $e');
    }
  }

  @override
  Future remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      prefs.remove(key);
    } catch (e) {
      devPrint('Error removing $key from local storage - $e');
    }
  }
}
