import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist/screens/home.dart';

final lightColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color.fromARGB(255, 246, 255, 0),
  onPrimary: Colors.amber[100],
  secondary: const Color.fromARGB(255, 255, 255, 255),
  tertiary: const Color.fromARGB(255, 0, 0, 0),
);
final darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 52, 69, 75),
  secondary: const Color.fromARGB(255, 0, 0, 0),
  tertiary: const Color.fromARGB(255, 255, 255, 255),
);

final lightTheme = ThemeData().copyWith(
  scaffoldBackgroundColor: lightColorScheme.secondary,
  colorScheme: lightColorScheme,
  textTheme: GoogleFonts.openSansTextTheme().copyWith(
    titleSmall: GoogleFonts.openSans(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.openSans(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.openSans(
      fontWeight: FontWeight.bold,
    ),
  ),
);
final darkTheme = ThemeData().copyWith(
  scaffoldBackgroundColor: darkColorScheme.secondary,
  colorScheme: darkColorScheme,
  textTheme: GoogleFonts.openSansTextTheme().copyWith(
    titleSmall: GoogleFonts.openSans(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.openSans(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.openSans(
      fontWeight: FontWeight.bold,
    ),
  ),
);

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Great Places',
      darkTheme: darkTheme,
      theme: lightTheme,
      home: const HomeScreen(),
    );
  }
}
