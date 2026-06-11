import 'api_service.dart';

class BookingService {
  static Future<Map<String, dynamic>> getUserBookings() {
    return ApiService.get('/user/bookings', auth: true);
  }

  static Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data) {
    return ApiService.post('/user/bookings', body: data, auth: true);
  }

  static Future<Map<String, dynamic>> getBooking(int bookingId) {
    return ApiService.get('/user/bookings/$bookingId', auth: true);
  }

  static Future<Map<String, dynamic>> cancelBooking(int bookingId) {
    return ApiService.post('/user/bookings/$bookingId/cancel', auth: true);
  }

  static Future<Map<String, dynamic>> adminGetBookings() {
    return ApiService.get('/admin/bookings', auth: true);
  }

  static Future<Map<String, dynamic>> adminGetBooking(int bookingId) {
    return ApiService.get('/admin/bookings/$bookingId', auth: true);
  }

  static Future<Map<String, dynamic>> adminUpdateBookingStatus(int bookingId, String status) {
    return ApiService.patch(
      '/admin/bookings/$bookingId/status',
      body: {'status': status},
      auth: true,
    );
  }
}
