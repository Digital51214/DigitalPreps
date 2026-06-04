import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      if (!mounted) return;

      Get.off(
        () => const OnboardingScreen(),
        transition: Transition.noTransition,
        duration: Duration.zero,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: w,
        height: h,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset('assets/images/sp1.png', fit: BoxFit.cover),
            ),

            // Center Logo
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Image.asset(
                  'assets/images/logo3.png',

                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
