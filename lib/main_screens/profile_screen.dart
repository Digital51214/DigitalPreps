import 'package:digital_preps/basic_files/app_colors.dart';
import 'package:digital_preps/main_screens/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isNotificationEnabled = true;

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔴 Icon Circle
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                  size: 34,
                ),
              ),

              const SizedBox(height: 16),

              /// Title
              Text(
                'Logout',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              /// Message
              Text(
                'Are You Sure You Want To Logout?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 5,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              /// Buttons Row
              Row(
                children: [
                  /// Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Logout Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // 👇 Apna logout logic yahan likhein
                        // Get.offAllNamed('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// 🔵 HEADER
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: h * 0.07,
              left: w * 0.08,
              bottom: h * 0.05,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFDFF6FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(w * 0.35),
                bottomRight: Radius.circular(w * 0.8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// PROFILE IMAGE
                Container(
                  padding: EdgeInsets.all(w * 0.01),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: CircleAvatar(
                    radius: w * 0.13,
                    backgroundImage: const AssetImage('assets/images/h1.png'),
                  ),
                ),

                SizedBox(height: h * 0.02),

                /// NAME
                Text(
                  'Muhammad Haseeb',
                  style: GoogleFonts.inter(
                    fontSize: w * 0.06,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkblue,
                  ),
                ),

                /// TITLE
                Text(
                  'UI UX Designer',
                  style: GoogleFonts.inter(
                    fontSize: w * 0.035,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: h * 0.05),

          /// EDIT PROFILE TILE
          GestureDetector(
            onTap: () {
              Get.to(
                EditProfileScreen(),
                transition: Transition.noTransition,
                duration: Duration.zero,
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.01,
                vertical: h * 0.01,
              ),
              child: Container(
                height: 65,
                width: 335,
                padding: EdgeInsets.symmetric(
                  vertical: w * 0.03,
                  horizontal: h * 0.04,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(w * 0.08),
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Profile',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: w * 0.035,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Profile Picture, your name, email, department',
                          style: GoogleFonts.inter(
                            fontSize: w * 0.025,
                            color: const Color(0xFF6B6A6A),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: w * 0.045,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// NOTIFICATION TILE
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.01,
              vertical: h * 0.01,
            ),
            child: Container(
              height: 65,
              width: 335,
              padding: EdgeInsets.symmetric(
                vertical: w * 0.03,
                horizontal: h * 0.04,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(w * 0.08),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifications',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: w * 0.035,
                        ),
                      ),
                      Text(
                        'Notification App',
                        style: GoogleFonts.inter(
                          fontSize: w * 0.025,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B6A6A),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Transform.scale(
                    scale: 0.80,
                    child: Switch(
                      value: isNotificationEnabled,
                      activeColor: Colors.lightBlue,
                      activeThumbColor: Colors.white,
                      activeTrackColor: Colors.lightBlue,
                      inactiveThumbColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          isNotificationEnabled = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: h * 0.04),

          /// LOGOUT BUTTON
          TextButton.icon(
            onPressed: () => _showLogoutDialog(context),
            icon: Icon(Icons.logout, color: Colors.redAccent, size: w * 0.05),
            label: Text(
              'Logout',
              style: GoogleFonts.inter(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
                fontSize: w * 0.045,
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}