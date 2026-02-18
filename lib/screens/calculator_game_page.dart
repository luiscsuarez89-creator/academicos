import 'dart:math';
import 'package:flutter/material.dart';
import 'package:academicos_calculadora/widgets/game_banner.dart';
import 'package:academicos_calculadora/utils/expression_evaluator.dart';

class CalculatorGamePage extends StatefulWidget {
  const CalculatorGamePage({super.key});

  @override
  State<CalculatorGamePage> createState() => _CalculatorGamePageState();
}

class _CalculatorGamePageState extends State<CalculatorGamePage> {
  static const List<String> _buttons = <String>[
    'C', '⌫', '(', ')',
    '7', '8', '9', '/',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    '0', '.', '^', '+',
    '=',
  ];

  String _expression = '';
  String _display = '0';
  String _status = 'Derrota al slime resolviendo operaciones.';

  double _playerHealth = 100;
  double _enemyHealth = 100;
  int _combo = 0;
  int _energy = 0;
  final Random _random = Random();

  void _onTap(String input) {
    if (_playerHealth <= 0 || _enemyHealth <= 0) {
      _resetBattle();
      return;
    }

    setState(() {
      if (input == 'C') {
        _expression = '';
        _display = '0';
        _status = 'Tablero limpio. ¡Siguiente movimiento!';
        _combo = 0;
        return;
      }

      if (input == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
          _display = _expression.isEmpty ? '0' : _expression;
          _status = 'Recalculando estrategia...';
        }
        return;
      }

      if (input == '=') {
        _resolveExpression();
        return;
      }

      _expression += input;
      _display = _expression;

      if (_isOperator(input)) {
        _combo += 1;
        _status = 'Combo +1: prepara ataque especial.';
      } else {
        _energy = min(100, _energy + 4);
        _status = 'Cargando energía: $_energy%';
      }
    });
  }

  void _resolveExpression() {
    try {
      final String expr = _expression.trim();
      if (expr.isEmpty) {
        throw const FormatException('No hay expresión.');
      }

      if (_detectDivisionByZero(expr)) {
        throw UnsupportedError('División por cero');
      }

      final double result = ExpressionEvaluator.evaluate(expr);
      _display = _formatResult(result);
      _expression = _display;

      final int damage = max(6, (result.abs() % 24).floor() + _combo * 3 + (_energy ~/ 20));
      _enemyHealth = max(0, _enemyHealth - damage);
      _status = '¡Impacto exitoso! Daño: $damage';
      _energy = min(100, _energy + 8);

      if (_enemyHealth <= 0) {
        _status = '¡Victoria! El slime fue derrotado.';
      } else {
        _enemyCounterAttack();
      }

      _combo = 0;
    } on UnsupportedError {
      _applyPenalty('¡Error crítico! División por cero.');
    } on FormatException catch (error) {
      _applyPenalty('Sintaxis inválida: ${error.message}');
    } catch (_) {
      _applyPenalty('Operación no válida.');
    }
  }

  void _enemyCounterAttack() {
    final int retaliation = _random.nextInt(9) + 4;
    _playerHealth = max(0, _playerHealth - retaliation);
    _status = 'El slime contraataca por $retaliation de daño.';

    if (_playerHealth <= 0) {
      _status = 'Has sido derrotado. Toca cualquier botón para reiniciar.';
    }
  }

  void _applyPenalty(String message) {
    final int penalty = 12 + _random.nextInt(8);
    _playerHealth = max(0, _playerHealth - penalty);
    _status = '$message Pierdes $penalty de salud.';
    _combo = 0;

    if (_playerHealth <= 0) {
      _status = 'Juego terminado por errores acumulados. Toca para reiniciar.';
    }
  }

  void _resetBattle() {
    _playerHealth = 100;
    _enemyHealth = 100;
    _combo = 0;
    _energy = 0;
    _expression = '';
    _display = '0';
    _status = 'Nueva partida: ¡derrota al slime con matemáticas!';
  }

  bool _detectDivisionByZero(String expression) {
    final String compact = expression.replaceAll(' ', '');
    return compact.contains('/0') || compact.contains('/(0)');
  }

  bool _isOperator(String value) =>
      value == '+' || value == '-' || value == '*' || value == '/' || value == '^';

  String _formatResult(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsPrecision(8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10131E),
      appBar: AppBar(
        title: const Text('Calculadora Científica Arcade'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              GameBanner(
                playerHealth: _playerHealth,
                enemyHealth: _enemyHealth,
                status: _status,
                combo: _combo,
                energy: _energy,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF1A2032),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        _expression.isEmpty ? 'Ingresa tu operación...' : _expression,
                        style: const TextStyle(color: Colors.white54, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _display,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: _buttons.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.3,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final String label = _buttons[index];
                          final bool isEqual = label == '=';
                          final bool isOp = _isOperator(label);
                          return FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: isEqual
                                  ? Colors.green
                                  : isOp
                                      ? Colors.deepPurple
                                      : const Color(0xFF2B3450),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () => _onTap(label),
                            child: Text(
                              label,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
