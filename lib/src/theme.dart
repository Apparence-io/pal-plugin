import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class _PalThemeLightColors {

  static const Color dark = Color(0xFF03045E);
  static const Color blue = Color(0xFF0077B6);
  static const Color lightBlue = Color(0xFF00B4D8);
  static const Color cyan = Color(0xFF90E0EF);
  static const Color aqua = Color(0xFFCAF0F8);
  static const Color red = Color(0xFFeB5160);
  static const Color white = Color(0xFFFAFEFF);

  static const Gradient gradient1 = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      white,
      aqua,
    ]
  );
}


class _PalThemeColors {

  final Color dark;

  final Color color1, color2, color3, color4;

  final Color accent;

  final Color light;

  final Gradient bottomNavEditorGradient;

  const _PalThemeColors._({
    this.dark,
    this.color1, this.color2, this.color3, this.color4,
    this.accent,
    this.light,
    this.bottomNavEditorGradient
  });

  factory _PalThemeColors.light() => const _PalThemeColors._(
    dark: _PalThemeLightColors.dark,
    color1: _PalThemeLightColors.blue,
    color2: _PalThemeLightColors.lightBlue,
    color3: _PalThemeLightColors.cyan,
    color4: _PalThemeLightColors.aqua,
    light:  _PalThemeLightColors.white,
    accent: _PalThemeLightColors.red,
    bottomNavEditorGradient: _PalThemeLightColors.gradient1,
  );

}

/// use this to let all app get our custom theme from context
/// we have more colors than pure material
class PalTheme extends InheritedWidget {

  final PalThemeData theme;

  PalTheme({
    this.theme,
    Key key,
    @required Widget child,
  })
    : assert(child != null),
      super(key: key, child: child);

  static PalThemeData of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<PalTheme>().theme;

  @override
  bool updateShouldNotify(PalTheme old) {
    return false;
  }
}


class PalThemeData {

  _PalThemeColors colors;


  PalThemeData._(_PalThemeColors colors) {
    this.colors = colors;
  }

  factory PalThemeData.light() => PalThemeData._(_PalThemeColors.light());

  ThemeData buildTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      accentColor: colors.dark,
      primaryColor: colors.color1,
      primaryColorDark: colors.color2,
      primaryColorLight: colors.accent,
      accentColorBrightness: Brightness.dark,
      primaryColorBrightness: Brightness.dark,
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: colors.color4,
        textTheme: ButtonTextTheme.primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colors.color4,
        foregroundColor: colors.dark
      ),
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      textSelectionColor: Colors.white,
      backgroundColor: Colors.white,
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: colors.dark,
        displayColor: colors.dark,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: colors.dark,
      ),
      highlightColor: colors.color4,
    );
  }

  Gradient get bottomNavEditorGradient => colors.bottomNavEditorGradient;

  Color get highlightColor => colors.color4;
}



