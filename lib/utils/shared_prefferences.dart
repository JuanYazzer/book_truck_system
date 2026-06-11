import 'package:shared_preferences/shared_preferences.dart';

/// Singleton untuk mengakses SharedPreferences
/// Digunakan untuk menyimpan token dan user data
class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  late SharedPreferences _prefs;

  // Keys untuk storage
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _lastLoginKey = 'last_login';

  SharedPreferencesService._();

  /// Get singleton instance
  static Future<SharedPreferencesService> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferencesService._();
      _instance!._prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // ===================== TOKEN METHODS =====================

  /// Simpan token
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// Ambil token
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Hapus token
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// Hapus semua data (untuk logout)
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  // ===================== AUTH-SPECIFIC METHODS =====================

  /// Simpan token setelah login
  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(_tokenKey, token);
    await _prefs.setString(_lastLoginKey, DateTime.now().toIso8601String());
  }

  /// Ambil token yang disimpan
  String? getAuthToken() {
    return _prefs.getString(_tokenKey);
  }

  /// Check apakah ada token yang valid
  bool hasValidToken() {
    final token = _prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Hapus token (logout)
  Future<void> clearAuthToken() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_usernameKey);
    await _prefs.remove(_lastLoginKey);
  }

  /// Simpan user info setelah login
  Future<void> saveUserInfo({
    required int userId,
    required String username,
  }) async {
    await _prefs.setInt(_userIdKey, userId);
    await _prefs.setString(_usernameKey, username);
  }

  /// Ambil username
  String? getUsername() {
    return _prefs.getString(_usernameKey);
  }

  /// Ambil user ID
  int? getUserId() {
    return _prefs.getInt(_userIdKey);
  }

  /// Ambil waktu login terakhir
  DateTime? getLastLogin() {
    final timestamp = _prefs.getString(_lastLoginKey);
    if (timestamp == null) return null;
    return DateTime.tryParse(timestamp);
  }
}
