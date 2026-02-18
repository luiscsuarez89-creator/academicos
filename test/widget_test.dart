import 'package:academicos_calculadora/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ExpressionEvaluator evalúa operaciones básicas', () {
    expect(ExpressionEvaluator.evaluate('2+2*3'), 8);
    expect(ExpressionEvaluator.evaluate('(10-4)^2'), 36);
  });

  testWidgets('Renderiza la calculadora arcade', (WidgetTester tester) async {
    await tester.pumpWidget(const ArcadeCalculatorApp());

    expect(find.text('Calculadora Científica Arcade'), findsOneWidget);
    expect(find.text('Slime'), findsOneWidget);
    expect(find.text('='), findsOneWidget);
  });
}
