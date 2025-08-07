import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Money source title
  static TextStyle moneySourceTitle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  // Money source amount
  static TextStyle moneySourceAmount = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );
  // Group title
  static TextStyle groupTitle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // Expense itemtitle
  static TextStyle expenseItemTitle = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  // Expense item info
  static TextStyle expenseItemInfo = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
}
