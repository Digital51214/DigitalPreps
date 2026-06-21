import 'package:digital_preps/basic_files/app_buttons.dart';
import 'package:digital_preps/basic_files/app_colors.dart';
import 'package:digital_preps/basic_files/main_screen.dart';
import 'package:digital_preps/basic_files/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../basic_files/check_box.dart';
import '../services/login_service.dart';
import '../services/session_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool isLoading = false;

  final LoginService _loginService = LoginService();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    print('─────────────────────────────────────────────────');
    print('🔵 LOGIN BUTTON TAPPED');

    // ── Empty field check ──────────────────────────────────────────────────
    if (username.isEmpty || password.isEmpty) {
      print('⚠️  VALIDATION FAILED: Empty field(s) detected');
      print('   ➤ Username empty: ${username.isEmpty}');
      print('   ➤ Password empty: ${password.isEmpty}');
      Get.snackbar(
        'Error',
        'Please enter both username and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    print('✅ VALIDATION PASSED');
    print('   ➤ Username : $username');
    print('   ➤ Password : ${'*' * password.length}');

    setState(() => isLoading = true);
    print('⏳ LOADING STATE → true');

    try {
      print('📡 CALLING LOGIN SERVICE...');
      final response = await _loginService.login(username, password);
      print('📩 RESPONSE RECEIVED IN SCREEN: $response');

      // ── Success ────────────────────────────────────────────────────────
      if (response['status'] == 'success') {
        print('✅ LOGIN SUCCESSFUL → Saving session & navigating...');
        await SessionManager.saveUserSession(response);
        print('🚀 NAVIGATING → MainScreen');

        Get.offAll(
          const MainScreen(),
          transition: Transition.noTransition,
        );

        // ── Invalid credentials ──────────────────────────────────────────────
      } else {
        print('❌ LOGIN REJECTED BY SERVER');
        print('   ➤ Server status: ${response['status']}');
        print('   ➤ Message: ${response['message'] ?? 'No message'}');
        Get.snackbar(
          'Login Failed',
          response['message'] ?? 'Invalid username or password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }

      // ── Network Error ──────────────────────────────────────────────────────
    } catch (e) {
      print('📵 EXCEPTION CAUGHT IN LOGIN SCREEN');
      print('   ➤ Error type   : ${e.runtimeType}');
      print('   ➤ Error detail : $e');
      Get.snackbar(
        'Network Error',
        'Unable to connect. Please check your Login Credentials.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

    } finally {
      if (mounted) setState(() => isLoading = false);
      print('⏳ LOADING STATE → false');
      print('🔵 LOGIN PROCESS COMPLETED');
      print('─────────────────────────────────────────────────');
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.055,
            vertical: h * 0.012,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.01),

                // ── Logo ───────────────────────────────────────────────────
                Center(
                  child: Image.asset(
                    'assets/images/logo4.png',
                    height: h * 0.2,
                    width: w * 0.5,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: h * 0.05),

                // ── Welcome text ───────────────────────────────────────────
                Center(
                  child: Text(
                    'Welcome Back',
                    style: GoogleFonts.inter(
                      fontSize: w * 0.08,
                      fontWeight: FontWeight.w900,
                      color: AppColors.darkblue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: h * 0.001),

                Center(
                  child: Text(
                    'Login to your employ account',
                    style: GoogleFonts.inter(
                      fontSize: w * 0.035,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: h * 0.07),

                // ── Fields ─────────────────────────────────────────────────
                EmailTextField(
                  hintText: 'User Name or Email',
                  controller: usernameController,
                ),

                SizedBox(height: h * 0.010),

                PasswordTextField(
                  hintText: 'Password',
                  controller: passwordController,
                ),

                SizedBox(height: h * 0.015),

                // ── Remember Me ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      CircularCheckbox(
                        initialValue: rememberMe,
                        onChanged: (val) {
                          setState(() => rememberMe = val);
                          print('🔹 Remember Me toggled → $rememberMe');
                        },
                      ),
                      SizedBox(width: w * 0.02),
                      Text(
                        'Remember Me',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: w * 0.035,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: h * 0.04),

                // ── Login Button / Loader ──────────────────────────────────
                Center(
                  child: SizedBox(
                    width: w * 0.9,
                    child: isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0055FF),
                        strokeWidth: 3,
                      ),
                    )
                        : MainButton(
                      text: 'Login',
                      onTap: _handleLogin,
                    ),
                  ),
                ),

                SizedBox(height: h * 0.1),

                // ── Bottom Logo ────────────────────────────────────────────
                Center(
                  child: Image.asset('assets/images/logo2.png', height: 40),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}