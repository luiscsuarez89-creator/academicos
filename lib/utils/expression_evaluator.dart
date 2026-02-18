import 'dart:math';

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
            throw UnsupportedError('División por cero');
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
