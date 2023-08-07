import 'package:blank_project/flavor/flavor_utils.dart';
import 'package:blank_project/models/auth_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ISecureLocalStorage {
  Future<String?> get(String key);

  Future save(String key, String data);

  Future remove(String key);

  Future<AuthModel?> getTokens();

  void saveTokens(AuthModel signInModel);

  Future removeTokens();
}

class SecureLocalStorage extends ISecureLocalStorage {
  final storage = const FlutterSecureStorage();

  //Do not access this variables directly!!!
  static String? _globalAccessToken = '';
  static String? _globalRefreshToken = '';

  @override
  Future<String?> get(String key) async {
    try {
      return await storage.read(key: key);
    } catch (e) {
      devPrint('Error getting $key from local storage - $e');
      return null;
    }
  }

  @override
  Future save(String key, String data) async {
    try {
      await storage.write(key: key, value: data);
    } catch (e) {
      devPrint('Error saving $key to local storage - $e');
    }
  }

  @override
  Future remove(String key) async {
    try {
      await storage.delete(key: key);
    } catch (e) {
      devPrint('Error removing $key from local storage - $e');
    }
  }

  @override
  Future<AuthModel?> getTokens() async {
    if (_globalAccessToken != null && _globalRefreshToken != null) {
      if (_globalAccessToken!.isNotEmpty && _globalRefreshToken!.isNotEmpty) {
        return AuthModel(
          accessToken: _globalAccessToken,
          refreshToken: _globalRefreshToken,
        );
      }
    }

    try {
      _globalAccessToken = await storage.read(key: 'accessToken');
      _globalRefreshToken = await storage.read(key: 'refreshToken');
      if (_globalAccessToken == null || _globalRefreshToken == null) {
        return null;
      } else {
        return AuthModel(
          accessToken: _globalAccessToken,
          refreshToken: _globalRefreshToken,
        );
      }
    } catch (e) {
      devPrint('Error receiving tokens to localStorage - $e');
      return null;
    }
  }

  @override
  void saveTokens(AuthModel? signInModel) {
    try {
      if (signInModel != null) {
        _globalRefreshToken = signInModel.refreshToken;
        _globalAccessToken = signInModel.accessToken;

        save('accessToken', signInModel.accessToken!);
        save('refreshToken', signInModel.refreshToken!);
      }
    } catch (e) {
      devPrint('Error saving tokens to localStorage - $e');
    }
  }

  @override
  Future removeTokens() async {
    try {
      await remove('accessToken');
      await remove('refreshToken');
      SecureLocalStorage._globalAccessToken = '';
      SecureLocalStorage._globalRefreshToken = '';
    } catch (e) {
      devPrint('Error removing tokens - $e');
    }
  }
}
