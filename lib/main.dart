import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const ArcadeCalculatorApp());
}

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
        throw const UnsupportedError('División por cero');
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
              _GameBanner(
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

class _GameBanner extends StatelessWidget {
  const _GameBanner({
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
              _CharacterColumn(
                name: 'Tú',
                emoji: '🧙',
                health: playerHealth,
                color: Colors.cyanAccent,
              ),
              _CharacterColumn(
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

class _CharacterColumn extends StatelessWidget {
  const _CharacterColumn({
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

class ExpressionEvaluator {
  static final RegExp _tokenMatcher = RegExp(r'\d+\.\d+|\d+|[+\-*/^()]');

  static double evaluate(String input) {
    final List<String> tokens = _tokenize(input);
    final List<String> rpn = _toRpn(tokens);
    return _evalRpn(rpn);
  }

  static List<String> _tokenize(String input) {
    final String sanitized = input.replaceAll(' ', '');
    final List<String> tokens = <String>[];

    int index = 0;
    while (index < sanitized.length) {
      final Match? match = _tokenMatcher.matchAsPrefix(sanitized, index);
      if (match == null) {
        throw const FormatException('Caracter no permitido.');
      }
      final String token = match.group(0)!;
      tokens.add(token);
      index += token.length;
    }
    return tokens;
  }

  static List<String> _toRpn(List<String> tokens) {
    final List<String> output = <String>[];
    final List<String> operators = <String>[];

    for (int i = 0; i < tokens.length; i++) {
      final String token = tokens[i];

      if (_isNumber(token)) {
        output.add(token);
        continue;
      }

      if (token == '(') {
        operators.add(token);
        continue;
      }

      if (token == ')') {
        while (operators.isNotEmpty && operators.last != '(') {
          output.add(operators.removeLast());
        }
        if (operators.isEmpty) {
          throw const FormatException('Paréntesis desbalanceados.');
        }
        operators.removeLast();
        continue;
      }

      if (_isOperator(token)) {
        final bool unaryMinus =
            token == '-' && (i == 0 || tokens[i - 1] == '(' || _isOperator(tokens[i - 1]));
        if (unaryMinus) {
          output.add('0');
        }

        while (operators.isNotEmpty && _hasPrecedence(operators.last, token)) {
          output.add(operators.removeLast());
        }
        operators.add(token);
        continue;
      }

      throw const FormatException('Expresión no válida.');
    }

    while (operators.isNotEmpty) {
      final String op = operators.removeLast();
      if (op == '(') {
        throw const FormatException('Paréntesis desbalanceados.');
      }
      output.add(op);
    }

    return output;
  }

  static double _evalRpn(List<String> rpn) {
    final List<double> stack = <double>[];

    for (final String token in rpn) {
      if (_isNumber(token)) {
        stack.add(double.parse(token));
        continue;
      }

      if (stack.length < 2) {
        throw const FormatException('Faltan operandos.');
      }

      final double b = stack.removeLast();
      final double a = stack.removeLast();

      switch (token) {
        case '+':
          stack.add(a + b);
        case '-':
          stack.add(a - b);
        case '*':
          stack.add(a * b);
        case '/':
          if (b == 0) {
            throw const UnsupportedError('División por cero');
          }
          stack.add(a / b);
        case '^':
          stack.add(pow(a, b).toDouble());
        default:
          throw const FormatException('Operador desconocido.');
      }
    }

    if (stack.length != 1) {
      throw const FormatException('Expresión malformada.');
    }

    return stack.single;
  }

  static bool _isNumber(String token) => double.tryParse(token) != null;

  static bool _isOperator(String token) => token == '+' || token == '-' || token == '*' || token == '/' || token == '^';

  static bool _hasPrecedence(String top, String incoming) {
    if (top == '(' || top == ')') {
      return false;
    }

    final int topValue = _precedence(top);
    final int inValue = _precedence(incoming);
    if (topValue > inValue) {
      return true;
    }
    if (topValue < inValue) {
      return false;
    }

    return incoming != '^';
  }

  static int _precedence(String operator) {
    switch (operator) {
      case '+':
      case '-':
        return 1;
      case '*':
      case '/':
        return 2;
      case '^':
        return 3;
      default:
        return 0;
    }
  }
}
