// lib/shared/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF8AB4F8),            // небесно-синий — акцент
    onPrimary: Color(0xFF0B0F14),
    primaryContainer: Color(0xFF1E2A3A),
    onPrimaryContainer: Color(0xFFDEE9FF),

    secondary: Color(0xFF7FDBCA),          // бирюзовый — вторичный акцент
    onSecondary: Color(0xFF081210),
    secondaryContainer: Color(0xFF163C39),
    onSecondaryContainer: Color(0xFFCFF7EF),

    tertiary: Color(0xFFFFB86C),           // тёплый акцент для меток/звёзд
    onTertiary: Color(0xFF1A1206),
    tertiaryContainer: Color(0xFF3E2A11),
    onTertiaryContainer: Color(0xFFFFE8CD),

    error: Color(0xFFCF6679),
    onError: Color(0xFF370B0E),

    background: Color(0xFF0F1115),         // общий фон
    onBackground: Color(0xFFE2E6EB),

    surface: Color(0xFF171A21),            // фон карточек/панелей
    onSurface: Color(0xFFE2E6EB),
    surfaceVariant: Color(0xFF232833),     // слегка светлее для инпутов/чипов
    onSurfaceVariant: Color(0xFFBFC7D5),

    outline: Color(0xFF4B5565),
    shadow: Color(0xFF000000),

    inverseSurface: Color(0xFFE2E6EB),
    onInverseSurface: Color(0xFF14161A),
    inversePrimary: Color(0xFF2F5DA8),
    surfaceTint: Color(0xFF8AB4F8),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _darkScheme,
    scaffoldBackgroundColor: _darkScheme.background,

    appBarTheme: AppBarTheme(
      backgroundColor: _darkScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _AppConst.onSurface,
      ),
      iconTheme: const IconThemeData(color: _AppConst.onSurface),
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: _AppConst.onSurfaceVariant,
      textColor: _AppConst.onSurface,
    ),

    iconTheme: IconThemeData(color: _darkScheme.onSurface),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, height: 1.25),
      bodyMedium: TextStyle(fontSize: 14, height: 1.25),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      labelLarge: TextStyle(fontWeight: FontWeight.w600),
    ).apply(
      bodyColor: _darkScheme.onSurface,
      displayColor: _darkScheme.onSurface,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkScheme.primary,
        foregroundColor: _darkScheme.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: _darkScheme.outline),
        foregroundColor: _darkScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _darkScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkScheme.surfaceVariant,
      prefixIconColor: _darkScheme.onSurfaceVariant,
      suffixIconColor: _darkScheme.onSurfaceVariant,
      labelStyle: TextStyle(color: _darkScheme.onSurfaceVariant),
      hintStyle: TextStyle(color: _darkScheme.onSurfaceVariant.withOpacity(0.7)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _darkScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _darkScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _darkScheme.primary),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: _darkScheme.surfaceVariant,
      selectedColor: _darkScheme.primaryContainer,
      labelStyle: TextStyle(color: _darkScheme.onSurface),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide(color: _darkScheme.outline),
    ),

    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: MaterialStatePropertyAll(_darkScheme.surface),
        surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textStyle: TextStyle(color: _darkScheme.onSurface),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _darkScheme.surface,
      indicatorColor: _darkScheme.primaryContainer,
      elevation: 0,
      labelTextStyle: MaterialStateProperty.all(
        TextStyle(color: _darkScheme.onSurface),
      ),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        final selected = states.contains(MaterialState.selected);
        return IconThemeData(
          color: selected ? _darkScheme.primary : _darkScheme.onSurfaceVariant,
        );
      }),
    ),

    dividerTheme: DividerThemeData(
      color: _darkScheme.outline.withOpacity(0.5),
      thickness: 1,
      space: 24,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: _darkScheme.inverseSurface,
      contentTextStyle: TextStyle(color: _darkScheme.onInverseSurface),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

class _AppConst {
  static const onSurface = Color(0xFFE2E6EB);
  static const onSurfaceVariant = Color(0xFFBFC7D5);
}
