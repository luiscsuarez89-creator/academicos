import 'package:flutter/material.dart';
import 'package:academicos_calculadora/widgets/character_column.dart';

class GameBanner extends StatelessWidget {
  const GameBanner({
    super.key,
    required this.playerHealth,
    required this.enemyHealth,
    required this.status,
    required this.combo,
    required this.energy,
  });

  final double playerHealth;
  final double enemyHealth;
  final String status;
  final int combo;
  final int energy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2032),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CharacterColumn(
                name: 'Tú',
                emoji: '🧙',
                health: playerHealth,
                color: Colors.cyanAccent,
              ),
              CharacterColumn(
                name: 'Slime',
                emoji: enemyHealth > 30 ? '🟢' : '💀',
                health: enemyHealth,
                color: Colors.redAccent,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              const Text('Combo', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 8),
              Chip(
                label: Text('x$combo'),
                backgroundColor: Colors.deepPurple.shade300,
              ),
              const Spacer(),
              const Text('Energía', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 8),
              SizedBox(
                width: 90,
                child: LinearProgressIndicator(
                  value: energy / 100,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            status,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
