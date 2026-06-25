import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _defaultBaseUrl = 'http://127.0.0.1:8000/api/v1';

  static String get baseUrl =>
      const String.fromEnvironment('API_BASE_URL', defaultValue: _defaultBaseUrl);

  static Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (auth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  static Future<http.Response> download(
    String path, {
    bool auth = false,
  }) async {
    return await http.get(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(auth: auth),
    );
  }

  static Future<Map<String, dynamic>> get(
    String path, {
    bool auth = false,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(auth: auth),
      );
      return _handleResponse(response);
    } catch (e) {
      return _errorResponse(e.toString());
    }
  }

  static Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(auth: auth),
        body: jsonEncode(body ?? {}),
      );
      return _handleResponse(response);
    } catch (e) {
      return _errorResponse(e.toString());
    }
  }

  static Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(auth: auth),
        body: jsonEncode(body ?? {}),
      );
      return _handleResponse(response);
    } catch (e) {
      return _errorResponse(e.toString());
    }
  }

  static Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(auth: auth),
        body: jsonEncode(body ?? {}),
      );
      return _handleResponse(response);
    } catch (e) {
      return _errorResponse(e.toString());
    }
  }

  static Future<Map<String, dynamic>> delete(
    String path, {
    bool auth = false,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(auth: auth),
      );
      return _handleResponse(response);
    } catch (e) {
      return _errorResponse(e.toString());
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final dynamic decoded = jsonDecode(response.body);
      final Map<String, dynamic> jsonBody =
          decoded is Map<String, dynamic> ? decoded : {'data': decoded};

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'statusCode': response.statusCode,
          'data': jsonBody['data'] ?? jsonBody,
          'message': jsonBody['message'],
        };
      }

      return {
        'success': false,
        'statusCode': response.statusCode,
        'message': jsonBody['message'] ?? 'Request failed',
        'data': jsonBody['data'] ?? jsonBody,
        'errors': jsonBody['errors'],
      };
    } catch (_) {
      return {
        'success': false,
        'statusCode': response.statusCode,
        'message': 'Invalid JSON response',
        'data': response.body,
      };
    }
  }

  static Map<String, dynamic> _errorResponse(String message) {
    return {
      'success': false,
      'statusCode': 0,
      'message': message,
      'data': null,
    };
  }
}
