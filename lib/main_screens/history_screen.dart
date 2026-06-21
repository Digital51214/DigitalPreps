import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/attendance_history_service.dart';
import '../services/session_manager.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<String, dynamic>? _historyData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() => _loading = true);
    final now = DateTime.now();
    final result = await AttendanceHistoryService.fetchHistory(
      month: now.month.toString().padLeft(2, '0'),
      year: now.year.toString(),
    );

    if (result['success']) {
      setState(() {
        _historyData = result['data'];
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Failed to fetch history')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final stats = _historyData?['stats'] ?? {'present': 0, 'absent': 0, 'late': 0};
    final data = _historyData?['data'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.055, vertical: h * 0.012),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'My History',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: w * 0.06,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _openCalendarDialog(w, h),
                    child: CircleAvatar(
                      radius: w * 0.06,
                      backgroundColor: const Color(0xFF36BCFF).withOpacity(0.3),
                      child: SvgPicture.asset(
                        'assets/images/hicon.svg',
                        height: w * 0.05,
                        width: w * 0.045,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.015),
              Text(
                'Access your complete attendance history and\nreview your performance.',
                style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 10, color: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusCard('Present', stats['present'].toString(), w, h, [Color(0xFF36BCFF).withOpacity(0), Color(0xFF2B96CC), Color(0xFF207199).withOpacity(0)]),
                    _buildStatusCard('Absent', stats['absent'].toString(), w, h, [Color(0xFFFF3E40).withOpacity(0), Color(0xFFCC3233), Color(0xFF992526).withOpacity(0)]),
                    _buildStatusCard('Late', stats['late'].toString(), w, h, [Color(0xFF061B44).withOpacity(0), Color(0xFF0B2F77), Color(0xFF0F43AA).withOpacity(0)]),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ...data.map<Widget>((item) {
                final status = item['status'] ?? 'Absent';
                final isAbsent = status != 'Present';
                return AttendanceCard(
                  day: DateFormat('EEEE, d MMM').format(DateTime.parse(item['date'])),
                  hours: item['total_hours'] ?? '0 Hours',
                  working: 'Workday session',
                  punchIn: item['punch_in'] != null ? DateFormat('hh:mm a').format(DateTime.parse(item['punch_in'])) : null,
                  punchOut: item['punch_out'] != null ? DateFormat('hh:mm a').format(DateTime.parse(item['punch_out'])) : null,
                  isAbsent: isAbsent,
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(String label, String count, double w, double h, List<Color> gradientColors) {
    return Container(
      width: 96,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.inter(fontSize: w * 0.035, color: Colors.grey, fontWeight: FontWeight.w500)),
                  SizedBox(height: h * 0.005),
                  Text(count, style: GoogleFonts.inter(fontSize: w * 0.045, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A))),
                ],
              ),
            ),
          ),
          Container(
            width: 10,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: gradientColors),
            ),
          ),
        ],
      ),
    );
  }

  void _openCalendarDialog(double w, double h) {
    DateTime focusedDay = DateTime.now();
    DateTime? selectedDay;
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                backgroundColor: const Color(0xFF36BCFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(w * 0.05)),
                child: Container(
                  width: w * 0.8,
                  height: 450,
                  padding: EdgeInsets.all(w * 0.03),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: focusedDay,
                    selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                    onDaySelected: (selected, focused) {
                      setState(() {
                        selectedDay = selected;
                        focusedDay = focused;
                      });
                    },
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                      selectedDecoration: BoxDecoration(color: Colors.lightBlue, shape: BoxShape.circle),
                      defaultTextStyle: TextStyle(color: Colors.white),
                      weekendTextStyle: TextStyle(color: Colors.white),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(color: Colors.white),
                      leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                      rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AttendanceCard(
          day: "Monday, 6 April",
          hours: "8:45 Hours",
          working: 'Workday session',
          punchIn: "8:30 AM",
          punchOut: "5:15 PM",
        ),
        AttendanceCard(
          day: "Saturday, 4 April",
          hours: "7:50 Hours",
          working: 'Workday session',
          punchIn: "9:10 AM",
          punchOut: "5:00 PM",
        ),
        AttendanceCard(
          day: "Friday, 3 April",
          hours: "7:50 Hours",
          working: 'Workday session',
          punchIn: "9:10 AM",
          punchOut: "5:00 PM",
          isLate: true,
        ),

        /// 🔴 NEW ABSENT CARDS
        AbsentCard(day: "Thursday, 2 April"),
        AbsentCard(day: "Wednesday, 1 April"),
      ],
    );
  }
}

class AttendanceCard extends StatelessWidget {
  final String day;
  final String working;
  final String hours; // ✅ FIXED (removed ?)
  final String? punchIn;
  final String? punchOut;
  final bool isLate;
  final bool isAbsent;

  const AttendanceCard({
    super.key,
    required this.day,
    required this.hours, // now non-nullable
    required this.working,
    this.punchIn,
    this.punchOut,
    this.isLate = false,
    this.isAbsent = false,
  });

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      height: isAbsent ? 99 : 155,
      width: 332,
      margin: EdgeInsets.only(bottom: h * 0.02),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: isAbsent ? Color(0xFFFFFFFF).withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(w * 0.05),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: w * 0.05,
            offset: Offset(0, h * 0.005),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: h * 0.015),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF36BCFF),
                      borderRadius: BorderRadius.circular(w * 0.05),
                    ),
                    child: Text(
                      hours,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: h * 0.001),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              working,
              style: GoogleFonts.inter(
                fontSize: w * 0.03,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: h * 0.015),

          if (isAbsent)
            Text(
              "Absent • No punch data",
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.red,
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: w * 0.04,
                      backgroundColor: const Color(0xFF36BCFF).withOpacity(0.4),
                      child: CircleAvatar(
                        radius: w * 0.020,
                        backgroundColor: const Color(0xFF36BCFF),
                        child: Icon(
                          Icons.check,
                          size: w * 0.038,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Punch in",
                          style: GoogleFonts.inter(
                            fontSize: w * 0.025,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          punchIn ?? "",
                          style: GoogleFonts.inter(
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Row(
                  children: [
                    CircleAvatar(
                      radius: w * 0.04,
                      backgroundColor: const Color(0xFFFF3E40).withOpacity(0.4),
                      child: Icon(
                        Icons.logout,
                        size: w * 0.038,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Punch out",
                          style: GoogleFonts.inter(
                            fontSize: w * 0.025,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          punchOut ?? "",
                          style: GoogleFonts.inter(
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

          if (isLate)
            Padding(
              padding: EdgeInsets.only(top: h * 0.002),
              child: Text(
                "Late Entry",
                style: GoogleFonts.inter(
                  fontSize: w * 0.025,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AbsentCard extends StatelessWidget {
  final String day;

  const AbsentCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      height: 99,
      width: 332,
      margin: EdgeInsets.only(bottom: h * 0.02),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(w * 0.05),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: w * 0.05,
            offset: Offset(0, h * 0.005),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DAY + HOURS (optional)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "0 Hours",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: h * 0.01),

          Text(
            "Absent • No punch data",
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
