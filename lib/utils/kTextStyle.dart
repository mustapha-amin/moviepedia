import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

TextStyle kTextStyle(double? size, {Color? color, FontWeight? fontWeight}) {
  return GoogleFonts.lato(
    fontSize: size!.sp,
    color: color ?? Colors.white,
    fontWeight: fontWeight ?? FontWeight.normal,
  );
}
