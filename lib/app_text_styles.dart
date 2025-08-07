import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // 1.MoneySource
  static TextStyle moneySourceTitle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static TextStyle moneySourceAmount = GoogleFonts.poppins(
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );

  // 2.Group
  static TextStyle groupTitle = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  // 3.ExpenseItem
  static TextStyle expenseItemTitle = GoogleFonts.roboto(fontSize: 18);
  static TextStyle expenseItemInfo = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}
