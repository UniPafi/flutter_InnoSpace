import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final SharedPreferences _prefs;

  SessionManager(this._prefs);

  static const String _authTokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _managerIdKey = 'manager_id';
  static const String _userEmailKey = 'user_email';


  Future<void> saveSession({
    required String token,
    required int userId,
    required int managerId,
    String? email,

  }) async {
    await _prefs.setString(_authTokenKey, token);
    await _prefs.setInt(_userIdKey, userId);
    await _prefs.setInt(_managerIdKey, managerId);
    if (email != null) {
      await _prefs.setString(_userEmailKey, email);
    }
  }

  Future<void> clearSession() async {
    await _prefs.remove(_authTokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_managerIdKey);
    await _prefs.remove(_userEmailKey);
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

 String? getUserEmail() {
    return _prefs.getString(_userEmailKey);
  }

  bool isLoggedIn() {
    return _prefs.containsKey(_authTokenKey);
  }
}