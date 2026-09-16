import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/study_cards_page.dart';

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Cards',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffe4764d),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xfffffbf5),
        textTheme: GoogleFonts.manropeTextTheme(),
        useMaterial3: true,
      ),
      home: const StudyCardsPage(),
    );
  }
}
