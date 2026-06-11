import 'api_service.dart';

class ChatbotService {
  static Future<Map<String, dynamic>> getHistory() {
    return ApiService.get('/user/chatbot/history', auth: true);
  }

  static Future<Map<String, dynamic>> sendMessage(String message) {
    return ApiService.post(
      '/user/chatbot/send',
      body: {'message': message},
      auth: true,
    );
  }
}
