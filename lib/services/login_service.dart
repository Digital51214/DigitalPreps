import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static const String _baseUrl =
      'https://digitalpreps.com/api/public/api/login';

  Future<Map<String, dynamic>> login(String email, String password) async {
    print('📡 LOGIN SERVICE → Sending request to: $_baseUrl');
    print('   ➤ Email    : $email');
    print('   ➤ Password : ${'*' * password.length}');

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('📶 HTTP STATUS CODE: ${response.statusCode}');
    print('📦 RAW RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('✅ RESPONSE PARSED SUCCESSFULLY');
      print('   ➤ Status    : ${data['status']}');
      print('   ➤ User Type : ${data['user_type']}');
      return data;
    } else {
      print('❌ SERVER ERROR: Status code ${response.statusCode}');
      throw Exception('Failed to login. Status: ${response.statusCode}');
    }
  }
}