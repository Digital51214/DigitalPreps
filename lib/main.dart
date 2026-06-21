import 'package:digital_preps/intro_screens/splash_screen.dart';
import 'package:digital_preps/services/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  print('✅ GetStorage initialized');
  print('🔍 Session check → isLoggedIn: ${SessionManager.isLoggedIn}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}