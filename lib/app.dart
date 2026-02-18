import 'package:flutter/material.dart';
import 'package:academicos_calculadora/screens/calculator_game_page.dart';

class ArcadeCalculatorApp extends StatelessWidget {
  const ArcadeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora Arcade',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalculatorGamePage(),
    );
  }
}
