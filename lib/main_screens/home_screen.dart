import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  bool isCheckedIn = false;
  Duration duration = Duration.zero;
  Timer? timer;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        duration += const Duration(seconds: 1);
      });
    });
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  void handlePunch() {
    _controller.forward().then((_) => _controller.reverse());

    if (!isCheckedIn) {
      setState(() {
        isCheckedIn = true;
      });
      startTimer();
    } else {
      setState(() {
        isCheckedIn = false;
        duration = Duration.zero;
      });
      timer?.cancel();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(height: 10,),
              Container(
                width: double.infinity,
                height: h * 0.065,
                padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(w * 0.1),
                ),
                child: Row(
                  children: [
                    Text(
                      'Good Morning Haseeb',
                      style: GoogleFonts.inter(
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: w * 0.035,
                      backgroundImage: const AssetImage('assets/images/h1.png'),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.015),

              /// 📅 DATE
              Text(
                'Wednesday, April 8th, 2026',
                style: GoogleFonts.inter(fontSize: w * 0.035),
              ),

              SizedBox(height: h * 0.015),

              /// ⏰ CURRENT TIME
              Container(
                width: w * 0.4,
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: h * 0.01,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(w * 0.08),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Time',
                      style: TextStyle(fontSize: w * 0.025, color: Colors.blue),
                    ),
                    Text(
                      '08:00 AM',
                      style: GoogleFonts.inter(
                        fontSize: w * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.05),


              Center(
                child: GestureDetector(
                  onTap: handlePunch,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 240,
                      height: 240,
                      padding: const EdgeInsets.all(0), // 👈 ring aur thin
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCheckedIn
                            ? Colors.red.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          isCheckedIn
                              ? 'assets/images/h2.png'
                              : 'assets/images/h3.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),



              SizedBox(height: h * 0.025),

              /// ⏱ TIMER
              if (isCheckedIn)
                Center(
                  child: Text(
                    formatTime(duration),
                    style: TextStyle(
                      fontSize: w * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              SizedBox(height: h * 0.015),

              /// STATUS
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.05,
                    vertical: h * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: isCheckedIn
                        ? Colors.red.withOpacity(0.2)
                        : Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(w * 0.05),
                  ),
                  child: Text(
                    isCheckedIn ? '● Checked In' : '● Please Check In',
                    style: TextStyle(
                      color: isCheckedIn ? Colors.red : Colors.blue,
                      fontSize: w * 0.03,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(height: h * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
