import 'package:flutter/material.dart';

const Color themePrimary = Color(0xFFF27507);
const Color textBlack = Color(0xFF3A3A3A);
const Color midnightBlue = Color(0xFF1F2430);
const Color themeGrey = Color(0xFFF4F5F6);
const Color themeGrey2 = Color(0xFFEBF1EF);
const Color background = Color(0xFFEFEFEF);

// const Color themeBlack = Color(0xFF3A3A3A);
// const Color themeGreen = Color(0xFF17E114);
// const Color themeRed = Color(0xFFE13214);
BoxDecoration boxDec = BoxDecoration(
  color: themeGrey, //Color(0xfff4f5f6),
  borderRadius: BorderRadius.circular(10),
);
BoxDecoration cardDec = BoxDecoration(
  border: Border.all(color: themePrimary),
  color: Color(0xfff4f5f6),
  borderRadius: BorderRadius.circular(10),
);
TextStyle underline = TextStyle(decoration: TextDecoration.underline);
TextStyle titleTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 20,
);
TextStyle headingTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 16,
);
TextStyle subTitle1TextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 22,
);
TextStyle subTitle2TextStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
);
TextStyle body1TextStyle = TextStyle(
  fontSize: 16,
  color: textBlack,
);
TextStyle body2TextStyle = TextStyle(
  fontSize: 14,
);
TextStyle captionTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 12,
);
TextStyle buttonTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 14,
  letterSpacing: 0.02,
);
