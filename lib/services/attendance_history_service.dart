import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/session_manager.dart';

class AttendanceHistoryService {
  static const String _baseUrl =
      'https://digitalpreps.com/api/public/api/attendance/history';

  /// Fetch monthly attendance history
  static Future<Map<String, dynamic>> fetchHistory({required String month, required String year}) async {
    try {
      final body = {
        'user_id': SessionManager.userId, // get user id from session
        'month': month,
        'year': year,
      };

      print('➡️ Fetching history request: $body');

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
        return {'success': data['status'] == 'success', 'data': data};
      } else {
        return {'success': false, 'message': 'Server error: ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception: $e'};
    }
  }
}