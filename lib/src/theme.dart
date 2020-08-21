import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PalTheme {
  static final ThemeData light = _buildLightTheme();

  static ThemeData _buildLightTheme() {
    final ThemeData base = ThemeData.dark();

    const Color dark = Color(0xFF000767);
    const Color blue = Color(0xFF3681bd);
    const Color lightBlue = Color(0xFF53bbdc);
    const Color cyan = Color(0xFFa1e3f1);
    const Color aqua = Color(0xFF90E0EF);
    const Color red = Color(0xFFe7636a);

    return base.copyWith(
      accentColor: dark,
      accentColorBrightness: Brightness.dark,
      primaryColor: aqua,
      primaryColorDark: dark,
      primaryColorLight: aqua,
      primaryColorBrightness: Brightness.dark,
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: aqua,
        textTheme: ButtonTextTheme.primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: aqua, foregroundColor: dark),
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      textSelectionColor: Colors.white,
      backgroundColor: Colors.white,
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: dark,
        displayColor: dark,
      ),
    );
  }
}
