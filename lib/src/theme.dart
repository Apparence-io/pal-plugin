import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _PalThemeLightColors {
  static const Color dark = Color(0xFF03045E);
  static const Color black = Color(0xFF292931);
  static const Color blue = Color(0xFF0077B6);
  static const Color lightBlue = Color(0xFF00B4D8);
  static const Color cyan = Color(0xFF90E0EF);
  static const Color aqua = Color(0xFFCAF0F8);
  static const Color red = Color(0xFFe74c3c);
  static const Color white = Color(0xFFFAFEFF);
  static const Color gray = Color(0xFF4F4E57);
  static const Color green = Color(0xFF2ecc71);

  static const Gradient gradient1 = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      white,
      aqua,
    ],
  );
  static const Gradient gradient2 = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFF0D055E),
      Color(0xFF2C77B6),
    ],
  );
}

class _PalThemeColors {
  final Color dark;

  final Color black;

  final Color green;

  final Color color1, color2, color3, color4, color5;

  final Color accent;

  final Color light;

  final Gradient bottomNavEditorGradient;

  final Gradient settingsSilverGradient;

  const _PalThemeColors._({
    this.dark,
    this.black,
    this.color1,
    this.color2,
    this.color3,
    this.color4,
    this.color5,
    this.accent,
    this.green,
    this.light,
    this.bottomNavEditorGradient,
    this.settingsSilverGradient,
  });

  factory _PalThemeColors.light() => const _PalThemeColors._(
        dark: _PalThemeLightColors.dark,
        color1: _PalThemeLightColors.blue,
        black: _PalThemeLightColors.black,
        color2: _PalThemeLightColors.lightBlue,
        color3: _PalThemeLightColors.cyan,
        color4: _PalThemeLightColors.aqua,
        color5: _PalThemeLightColors.gray,
        light: _PalThemeLightColors.white,
        accent: _PalThemeLightColors.red,
        green: _PalThemeLightColors.green,
        bottomNavEditorGradient: _PalThemeLightColors.gradient1,
        settingsSilverGradient: _PalThemeLightColors.gradient2,
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
  })  : assert(child != null),
        super(key: key, child: child);

  static PalThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PalTheme>().theme;

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
    final ThemeData base = ThemeData.light();

    const Color dark = Color(0xFF000767);
    const Color blue = Color(0xFF3681bd); // ignore: unused_local_variable
    const Color lightBlue = Color(0xFF53bbdc); // ignore: unused_local_variable
    const Color cyan = Color(0xFFa1e3f1); // ignore: unused_local_variable
    const Color aqua = Color(0xFF90E0EF);
    const Color red = Color(0xFFe7636a); // ignore: unused_local_variable
    const Color black = Color(0xFF292931); // ignore: unused_local_variable
    const Color green = Color(0xFF1abc9c); // ignore: unused_local_variable

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
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: colors.color1),
        helperStyle: TextStyle(color: colors.color1),
        hintStyle: TextStyle(color: colors.dark.withAlpha(60)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.color1,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: aqua, foregroundColor: dark),
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.white),
      backgroundColor: Colors.white,
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: dark,
        displayColor: dark,
      ),
    );
  }

  Gradient get bottomNavEditorGradient => colors.bottomNavEditorGradient;

  Gradient get settingsSilverGradient => colors.settingsSilverGradient;

  Color get highlightColor => colors.color4;

  Color get toolbarBackgroundColor => colors.color5;

  Color get floatingBubbleBackgroundColor => colors.color1;

  Color get simpleHelperBackgroundColor => colors.black;

  Color get simpleHelperFontColor => Color(0xFFFAFEFF);
}
