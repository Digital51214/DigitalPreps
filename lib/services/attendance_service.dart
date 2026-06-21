import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/session_manager.dart';

class AttendanceService {
  static const String _baseUrl =
      'https://digitalpreps.com/api/public/api/attendance/punch';

  /// Punch In / Punch Out
  static Future<Map<String, dynamic>> punch(String status) async {
    try {
      final body = {
        'user_id': SessionManager.userId, // send as STRING
        'status': status,                 // "Punch In" / "Punch Out"
      };

      print('➡️ Request body: $body');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('⬅️ Response (${response.statusCode}): ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': data['status'] == 'success',
          'message': data['message'] ?? 'Success',
        };
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? 'Bad Request'};
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception: $e'};
    }
  }
}