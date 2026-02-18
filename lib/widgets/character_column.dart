import 'package:flutter/material.dart';

class CharacterColumn extends StatelessWidget {
  const CharacterColumn({
    super.key,
    required this.name,
    required this.emoji,
    required this.health,
    required this.color,
  });

  final String name;
  final String emoji;
  final double health;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(emoji, style: const TextStyle(fontSize: 30)),
        Text(name, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 5),
        SizedBox(
          width: 110,
          child: LinearProgressIndicator(
            value: health / 100,
            minHeight: 8,
            color: color,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: Colors.white12,
          ),
        ),
      ],
    );
  }
}
