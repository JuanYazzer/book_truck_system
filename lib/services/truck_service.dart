import 'api_service.dart';

class TruckService {
  static Future<Map<String, dynamic>> getTrucks() {
    return ApiService.get('/trucks');
  }

  static Future<Map<String, dynamic>> getTruck(int truckId) {
    return ApiService.get('/trucks/$truckId');
  }

  static Future<Map<String, dynamic>> adminGetTrucks() {
    return ApiService.get('/admin/trucks', auth: true);
  }

  static Future<Map<String, dynamic>> adminCreateTruck(Map<String, dynamic> data) {
    return ApiService.post('/admin/trucks', body: data, auth: true);
  }

  static Future<Map<String, dynamic>> adminUpdateTruck(int truckId, Map<String, dynamic> data) {
    return ApiService.put('/admin/trucks/$truckId', body: data, auth: true);
  }

  static Future<Map<String, dynamic>> adminDeleteTruck(int truckId) {
    return ApiService.delete('/admin/trucks/$truckId', auth: true);
  }
}
