import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // 1.Total balanced
  static TextStyle MainFont = GoogleFonts.kalam(fontSize: 22);
  static TextStyle Totalbalancedamount = GoogleFonts.charm(
    fontSize: 50,
    fontWeight: FontWeight.w500,
  );

  // 2.MoneySource
  static TextStyle moneySourceTitle = GoogleFonts.kalam(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
  static TextStyle moneySourceAmount = GoogleFonts.patrickHand(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static TextStyle moneySourceAddButton = GoogleFonts.kalam(fontSize: 15);

  // 3.Transfrare/recieve
  static TextStyle AddTitle = GoogleFonts.kalam(fontSize: 16);

  // 4.ExpenseItem
  static TextStyle expenseItemTitle = GoogleFonts.kalam(fontSize: 25);
  static TextStyle expenseItemamount = GoogleFonts.patrickHand(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );
  static TextStyle groupTitle = GoogleFonts.caveat(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle expenseItemdate = GoogleFonts.kalam(fontSize: 12);
}
