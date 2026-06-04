
// import 'package:digital_preps/basic_files/app_buttons.dart';
// import 'package:digital_preps/basic_files/app_colors.dart';
// import 'package:digital_preps/intro_screens/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class OnboardingModel {
//   final String image;
//   final String title;
//   final String subtitle;
//
//   OnboardingModel({
//     required this.image,
//     required this.title,
//     required this.subtitle,
//   });
// }
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController();
//   int currentIndex = 0;
//
//   final List<OnboardingModel> onboardingData = [
//     OnboardingModel(
//       image: 'assets/images/on1.png',
//       title: 'Track Your Attendance\nEffortlessly',
//       subtitle:
//       'Streamline your workday with our\nintuitive digital clock-in system.',
//     ),
//     OnboardingModel(
//       image: 'assets/images/on2.png',
//       title: 'Punch In & Punch\nOut With One Tap',
//       subtitle:
//       'No more manual logs. Simplify\nyour workflow with smart tracker.',
//     ),
//     OnboardingModel(
//       image: 'assets/images/on3.png',
//       title: 'Stay Alert, Never\nMiss a Check Out',
//       subtitle:
//       'Real time reminders keep you\ninformed about your attendance.',
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     double h = MediaQuery.of(context).size.height;
//     double w = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: onboardingData.length,
//                 onPageChanged: (index) {
//                   setState(() {
//                     currentIndex = index;
//                   });
//                 },
//                 itemBuilder: (context, index) {
//                   final data = onboardingData[index];
//
//                   return Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: w * 0.055,
//                       vertical: h * 0.012,
//                     ),
//                     child: Column(
//                       children: [
//                         SizedBox(height: h * 0.02),
//
//                         SizedBox(
//                           height: h * 0.42,
//                           width: w * 0.75,
//                           child: Image.asset(
//                             data.image,
//                             fit: BoxFit.contain,
//                           ),
//                         ),
//
//                         SizedBox(height: h * 0.03),
//
//                         Text(
//                           data.title,
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.inter(
//                             fontSize: w * 0.07,
//                             fontWeight: FontWeight.w900,
//                             color: const Color(0xFF061B44),
//                             height: 1.2,
//                           ),
//                         ),
//
//                         SizedBox(height: h * 0.02),
//
//                         Text(
//                           data.subtitle,
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.inter(
//                             fontSize: w * 0.045,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//
//                         SizedBox(height: h * 0.04),
//
//                         // INDICATORS moved inside PageView
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: List.generate(
//                             onboardingData.length,
//                                 (indicatorIndex) => Padding(
//                               padding: EdgeInsets.symmetric(horizontal: w * 0.01),
//                               child: _buildIndicator(
//                                 isActive: currentIndex == indicatorIndex,
//                                 w: w,
//                                 h: h,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // BUTTON STAYS OUTSIDE (same as you wanted)
//             Padding(
//               padding: EdgeInsets.only(
//                 bottom: h * 0.03,
//                 left: w * 0.05,
//                 right: w * 0.05,
//               ),
//               child: SizedBox(
//                 width: w * 0.9,
//                 child: RoundButton(
//                   text: currentIndex == onboardingData.length - 1
//                       ? 'Get Started'
//                       : 'Next',
//                   onTap: () {
//                     if (currentIndex == onboardingData.length - 1) {
//                       Get.to(
//                         const LoginScreen(),
//                         transition: Transition.noTransition,
//                         duration: Duration.zero,
//                       );
//                     } else {
//                       _pageController.nextPage(
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeInOut,
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildIndicator({
//     required bool isActive,
//     required double w,
//     required double h,
//   }) {
//     return Container(
//       height: h * 0.01,
//       width: isActive ? w * 0.15 : w * 0.07,
//       decoration: BoxDecoration(
//         color: isActive
//             ? AppColors.bluemain
//             : const Color(0xFF061B44).withOpacity(0.3),
//         borderRadius: BorderRadius.circular(10),
//       ),
//     );
//   }
// }
import 'package:digital_preps/basic_files/app_buttons.dart';
import 'package:digital_preps/basic_files/app_colors.dart';
import 'package:digital_preps/intro_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String subtitle;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<OnboardingModel> onboardingData = [
    OnboardingModel(
      image: 'assets/images/on1.png',
      title: 'Track Your Attendance\nEffortlessly',
      subtitle:
      'Streamline your workday with our\nintuitive digital clock-in system.',
    ),
    OnboardingModel(
      image: 'assets/images/on2.png',
      title: 'Punch In & Punch\nOut With One Tap',
      subtitle:
      'No more manual logs. Simplify\nyour workflow with smart tracker.',
    ),
    OnboardingModel(
      image: 'assets/images/on3.png',
      title: 'Stay Alert, Never\nMiss a Check Out',
      subtitle:
      'Real time reminders keep you\ninformed about your attendance.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 🔵 TOP PAGEVIEW (image + text)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final data = onboardingData[index];

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.06,

                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          data.image,
                          height:342,
                          width: 303,
                          fit: BoxFit.contain,
                        ),

                        SizedBox(height: h * 0.04),

                        Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF061B44),
                            height: 1.2,
                          ),
                        ),

                        SizedBox(height: h * 0.02),

                        Text(
                          data.subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 🔵 FIXED INDICATOR (NOT INSIDE PAGEVIEW)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: w * 0.01),
                  height: h * 0.01,
                  width: currentIndex == index ? w * 0.15 : w * 0.07,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? AppColors.bluemain
                        : const Color(0xFF061B44).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            SizedBox(height: h * 0.03),

            // 🔵 BUTTON (FIXED)
            Padding(
              padding: EdgeInsets.only(
                bottom: h * 0.03,
                left: w * 0.05,
                right: w * 0.05,
              ),
              child: SizedBox(
                width: w * 0.9,
                child: RoundButton(
                  text: currentIndex == onboardingData.length - 1
                      ? 'Get Started'
                      : 'Next',
                  onTap: () {
                    if (currentIndex == onboardingData.length - 1) {
                      Get.to(
                        const LoginScreen(),
                        transition: Transition.noTransition,
                        duration: Duration.zero,
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}