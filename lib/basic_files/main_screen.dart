import 'package:digital_preps/main_screens/history_screen.dart';
import 'package:digital_preps/main_screens/home_screen.dart';
import 'package:digital_preps/main_screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    AttendanceScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[selectedIndex],

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: h * 0.05,right: w * 0.05,left: w * 0.05,
        ),
        child: Container(
          height: 62,

          width: 220,
          decoration: BoxDecoration(
            color: const Color(0xFF36BCFF).withOpacity(0.8),
            borderRadius: BorderRadius.circular(w * 0.1),
            border: Border.all(
              width: w * 0.008,
              color: const Color(0xFF36BCFF),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              navItem(Icons.home, 0, w, h),
              navItem(Icons.history, 1, w, h),
              navItem(Icons.person, 2, w, h),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem(IconData icon, int index, double w, double h) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(w * 0.025),
        decoration: isSelected
            ? const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF36BCFF),
              )
            : const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Inner shadow (only when selected)
            if (isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),

            Icon(icon, color: Colors.white, size: w * 0.07),
          ],
        ),
      ),
    );
  }
}
