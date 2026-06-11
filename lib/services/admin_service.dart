import 'api_service.dart';

class AdminService {
  static Future<Map<String, dynamic>> getDashboard() {
    return ApiService.get('/admin/dashboard', auth: true);
  }

  static Future<Map<String, dynamic>> getChartData() {
    return ApiService.get('/admin/dashboard/chart-data', auth: true);
  }

  static Future<Map<String, dynamic>> getActivityLogs() {
    return ApiService.get('/admin/activity-logs', auth: true);
  }

  static Future<Map<String, dynamic>> exportBookingsExcel() {
    return ApiService.get('/admin/bookings/export/excel', auth: true);
  }

  static Future<Map<String, dynamic>> exportBookingsPdf() {
    return ApiService.get('/admin/bookings/export/pdf', auth: true);
  }
}
