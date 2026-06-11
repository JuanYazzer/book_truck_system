import 'api_service.dart';

class CompanyService {
  static Future<Map<String, dynamic>> getInfo() {
    return ApiService.get('/company/info');
  }

  static Future<Map<String, dynamic>> getAbout() {
    return ApiService.get('/company/about');
  }

  static Future<Map<String, dynamic>> getContact() {
    return ApiService.get('/company/contact');
  }
}
