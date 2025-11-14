import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final SharedPreferences _prefs;

  SessionManager(this._prefs);

  static const String _authTokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _managerIdKey = 'manager_id';

  Future<void> saveSession({
    required String token,
    required int userId,
    required int managerId,
  }) async {
    await _prefs.setString(_authTokenKey, token);
    await _prefs.setInt(_userIdKey, userId);
    await _prefs.setInt(_managerIdKey, managerId);
  }

  Future<void> clearSession() async {
    await _prefs.remove(_authTokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_managerIdKey);
  }

  String? getAuthToken() {
    return _prefs.getString(_authTokenKey);
  }

  int? getUserId() {
    return _prefs.getInt(_userIdKey);
  }
  
  int? getManagerId() {
    return _prefs.getInt(_managerIdKey);
  }

  bool isLoggedIn() {
    return _prefs.containsKey(_authTokenKey);
  }
}