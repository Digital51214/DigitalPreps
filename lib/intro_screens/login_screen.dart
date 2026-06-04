import 'package:digital_preps/basic_files/app_buttons.dart';
import 'package:digital_preps/basic_files/app_colors.dart';
import 'package:digital_preps/basic_files/main_screen.dart';
import 'package:digital_preps/basic_files/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../basic_files/check_box.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool rememberMe = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
          child: Form(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h * 0.01),

                  Center(
                    child: Image.asset(
                      'assets/images/logo4.png',
                      height: h * 0.2,
                      width: w * 0.5,

                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: h * 0.05),

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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        CircularCheckbox(
                          initialValue: rememberMe,
                          onChanged: (val) {
                            setState(() {
                              rememberMe = val;
                            });
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

                  Center(
                    child: SizedBox(
                      width: w * 0.9,
                      child: MainButton(
                        text: 'Login',
                        onTap: () {
                          Get.to(
                            MainScreen(),
                            transition: Transition.noTransition,
                            duration: Duration.zero,
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.1),
                  Center(child: Image.asset('assets/images/logo2.png', height: 40)),
                ],
              ),
            ),
          ),
        ),

    );
  }
}