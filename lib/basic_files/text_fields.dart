import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final double width;
  final double height;

  const
  EmailTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.width = 335,
    this.height = 45,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color(0xFFD9D9D9),
      ),
      width: width,
      height: height,

      child: TextFormField(
        textAlign: TextAlign.start,
        controller: controller,
        keyboardType: TextInputType.emailAddress, // Email keyboard
        style: GoogleFonts.inter(
          color: Color(0xFF979696),
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          // contentPadding: const EdgeInsets.symmetric(
          //   horizontal: 20,
          //   vertical: 14,
          // ),
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            color: Color(0xFF979696),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final double width;
  final double height;
  final int maxLength;

  const PasswordTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.width = 335,
    this.height = 48,
    this.maxLength = 20,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),

        color: Color(0xFFD9D9D9),
      ),
      child: TextFormField(
        textAlign: TextAlign.start,
        controller: widget.controller,
        obscureText: _obscure,
        maxLength: widget.maxLength,
        style: GoogleFonts.inter(
          color: Color(0xFF979696),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          counterText: "",

          // ✨ Hint Text
          hintText: widget.hintText,
          hintStyle: GoogleFonts.inter(
            color: Color(0xFF979696),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),

          // ❌ Remove underline
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,

          // 👁 Eye icon (like image)
          suffixIcon: IconButton(
            icon: Icon(
              _obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Color(0xFFD9D9D9),
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _obscure = !_obscure;
              });
            },
          ),
        ),
      ),
    );
  }
}
