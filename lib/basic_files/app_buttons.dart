import 'package:digital_preps/basic_files/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const RoundButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 335,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.bluemain,
            borderRadius: BorderRadius.circular(screenWidth * 0.1),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),

                /// 👉 Arrow Icon
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      );
  }
}

class MainButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const MainButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 335,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.bluemain,
          borderRadius: BorderRadius.circular(screenWidth * 0.1),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,

            ),
          ),
        ),
      ),
    );
  }
}