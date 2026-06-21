import 'package:get_storage/get_storage.dart';

class SessionManager {
  static final _box = GetStorage();

  static const _keyToken     = 'token';
  static const _keyUserType  = 'user_type';
  static const _keyUserId    = 'user_id';
  static const _keyUserName  = 'user_name';
  static const _keyUserEmail = 'user_email';
  static const _keyUserRole  = 'user_role';

  static Future<void> saveUserSession(Map<String, dynamic> response) async {
    print('💾 SESSION MANAGER → Saving session data...');

    final user = response['user'] ?? {};

    _box.write(_keyToken,     response['token']?.toString()     ?? '');
    _box.write(_keyUserType,  response['user_type']?.toString() ?? '');
    _box.write(_keyUserId,    user['id']?.toString()            ?? '');
    _box.write(_keyUserName,  user['name']?.toString()          ?? '');
    _box.write(_keyUserEmail, user['email']?.toString()         ?? '');
    _box.write(_keyUserRole,  (user['role'] ?? response['user_type'])?.toString() ?? '');

    print('   ➤ Token     : ${response['token']     ?? 'N/A'}');
    print('   ➤ User Type : ${response['user_type'] ?? 'N/A'}');
    print('   ➤ User ID   : ${user['id']            ?? 'N/A'}');
    print('   ➤ User Name : ${user['name']          ?? 'N/A'}');
    print('   ➤ Email     : ${user['email']         ?? 'N/A'}');
    print('   ➤ Role      : ${user['role']          ?? 'N/A'}');
    print('✅ SESSION SAVED SUCCESSFULLY');
  }

  static String get token     => _box.read(_keyToken)?.toString()     ?? '';
  static String get userType  => _box.read(_keyUserType)?.toString()  ?? '';
  static String get userId    => _box.read(_keyUserId)?.toString()    ?? '';
  static String get userName  => _box.read(_keyUserName)?.toString()  ?? '';
  static String get userEmail => _box.read(_keyUserEmail)?.toString() ?? '';
  static String get userRole  => _box.read(_keyUserRole)?.toString()  ?? '';

  static bool get isLoggedIn {
    final loggedIn = token.isNotEmpty;
    print('🔍 SESSION CHECK → isLoggedIn: $loggedIn');
    return loggedIn;
  }

  static void clearSession() {
    print('🗑️  SESSION MANAGER → Clearing all session data...');
    _box.erase();
    print('✅ SESSION CLEARED');
  }
}