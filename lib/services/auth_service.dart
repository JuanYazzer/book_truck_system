import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) {
    return ApiService.post('/auth/register', body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return ApiService.post('/auth/login', body: {
      'email': email,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('user_role') ?? 'user';
    final endpoint = role == 'admin' ? '/admin/auth/logout' : '/user/auth/logout';
    return ApiService.post(endpoint, auth: true);
  }

  static Future<Map<String, dynamic>> getProfile() {
    return ApiService.get('/user/profile', auth: true);
  }
}
