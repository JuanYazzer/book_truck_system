import 'api_service.dart';

class PaymentService {
  static Future<Map<String, dynamic>> getSnapToken(int bookingId) {
    return ApiService.post(
      '/user/bookings/$bookingId/payment/snap-token',
      auth: true,
    );
  }

  static Future<Map<String, dynamic>> getPaymentStatus(int bookingId) {
    return ApiService.get('/user/bookings/$bookingId/payment', auth: true);
  }
}
