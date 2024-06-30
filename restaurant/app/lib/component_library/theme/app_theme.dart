import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class AppTheme {
  const AppTheme({required this.context, this.brightness = Brightness.dark});
  final BuildContext context;
  final Brightness brightness;

  ThemeData theme() {
    TextTheme textTheme = _createTextTheme(
      context,
      "Source Code Pro",
      "Source Code Pro",
    );

    final appTheme = _AppTheme(textTheme);

    return appTheme.light();
  }

  TextTheme _createTextTheme(
      BuildContext context, String bodyFontString, String displayFontString) {
    TextTheme baseTextTheme = Theme.of(context).textTheme;
    TextTheme bodyTextTheme =
        GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
    TextTheme displayTextTheme =
        GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
    TextTheme textTheme = displayTextTheme.copyWith(
      bodyLarge: bodyTextTheme.bodyLarge,
      bodyMedium: bodyTextTheme.bodyMedium,
      bodySmall: bodyTextTheme.bodySmall,
      labelLarge: bodyTextTheme.labelLarge,
      labelMedium: bodyTextTheme.labelMedium,
      labelSmall: bodyTextTheme.labelSmall,
    );
    return textTheme;
  }
}

class _AppTheme {
  final TextTheme textTheme;

  const _AppTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff904a47),
      surfaceTint: Color(0xff904a47),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdad7),
      onPrimaryContainer: Color(0xff3b080a),
      secondary: Color(0xff775654),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdad7),
      onSecondaryContainer: Color(0xff2c1514),
      tertiary: Color(0xff735b2e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffdea8),
      onTertiaryContainer: Color(0xff271900),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff231919),
      onSurfaceVariant: Color(0xff534342),
      outline: Color(0xff857371),
      outlineVariant: Color(0xffd8c2c0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e2d),
      inversePrimary: Color(0xffffb3af),
      primaryFixed: Color(0xffffdad7),
      onPrimaryFixed: Color(0xff3b080a),
      primaryFixedDim: Color(0xffffb3af),
      onPrimaryFixedVariant: Color(0xff733331),
      secondaryFixed: Color(0xffffdad7),
      onSecondaryFixed: Color(0xff2c1514),
      secondaryFixedDim: Color(0xffe7bdba),
      onSecondaryFixedVariant: Color(0xff5d3f3d),
      tertiaryFixed: Color(0xffffdea8),
      onTertiaryFixed: Color(0xff271900),
      tertiaryFixedDim: Color(0xffe2c28c),
      onTertiaryFixedVariant: Color(0xff594319),
      surfaceDim: Color(0xffe8d6d4),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ef),
      surfaceContainer: Color(0xfffceae8),
      surfaceContainerHigh: Color(0xfff6e4e2),
      surfaceContainerHighest: Color(0xfff1dedd),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );
}
