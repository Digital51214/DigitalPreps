import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../services/session_manager.dart';
import '../services/attendance_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  bool isCheckedIn = false;
  Duration duration = Duration.zero;
  Timer? _attendanceTimer;
  Timer? _clockTimer;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  late DateTime _now;

  DateTime get _pkTime => _now.toUtc().add(const Duration(hours: 5));
  String get _liveTime => DateFormat('hh:mm:ss a').format(_pkTime);
  String get _liveDate =>
      DateFormat('MMMM d').format(_pkTime) + _daySuffix(_pkTime.day) + DateFormat(', yyyy').format(_pkTime);
  String get _liveDay => DateFormat('EEEE').format(_pkTime);

  String _daySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);

    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _attendanceTimer?.cancel();
    _clockTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAttendanceTimer() {
    _attendanceTimer?.cancel();
    _attendanceTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => duration += const Duration(seconds: 1));
    });
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }

  Future<void> _handlePunch() async {
    _controller.forward().then((_) => _controller.reverse());
    final status = isCheckedIn ? 'Punch Out' : 'Punch In';

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final result = await AttendanceService.punch(status);

    Navigator.pop(context); // remove loading

    if (result['success']) {
      if (!isCheckedIn) {
        setState(() {
          isCheckedIn = true;
          duration = Duration.zero;
        });
        _startAttendanceTimer();
      } else {
        _attendanceTimer?.cancel();
        setState(() {
          isCheckedIn = false;
          duration = Duration.zero;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${result['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    final displayName = SessionManager.userName.isNotEmpty ? SessionManager.userName : 'User';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.055, vertical: h * 0.012),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
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
                      'Good Morning $displayName',
                      style: GoogleFonts.inter(fontSize: w * 0.045, fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    CircleAvatar(radius: w * 0.035, backgroundImage: const AssetImage('assets/images/h1.png')),
                  ],
                ),
              ),
              SizedBox(height: h * 0.015),
              Text('$_liveDay, $_liveDate', style: GoogleFonts.inter(fontSize: w * 0.035, fontWeight: FontWeight.w500, color: Colors.black87)),
              SizedBox(height: h * 0.015),
              Container(
                width: w * 0.4,
                padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.01),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(w * 0.08)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Current Time (PKT)', style: TextStyle(fontSize: w * 0.025, color: Colors.blue)),
                  Text(_liveTime, style: GoogleFonts.inter(fontSize: w * 0.038, fontWeight: FontWeight.bold)),
                ]),
              ),
              SizedBox(height: h * 0.05),
              Center(
                child: GestureDetector(
                  onTap: _handlePunch,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCheckedIn ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          isCheckedIn ? 'assets/images/h2.png' : 'assets/images/h3.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: h * 0.025),
              if (isCheckedIn)
                Center(
                  child: Text(_formatDuration(duration), style: TextStyle(fontSize: w * 0.07, fontWeight: FontWeight.bold)),
                ),
              SizedBox(height: h * 0.015),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.01),
                  decoration: BoxDecoration(
                    color: isCheckedIn ? Colors.red.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(w * 0.05),
                  ),
                  child: Text(isCheckedIn ? '● Checked In' : '● Please Check In',
                      style: TextStyle(color: isCheckedIn ? Colors.red : Colors.blue, fontSize: w * 0.03)),
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