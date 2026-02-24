import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servicios_computadores_bogota_web/main.dart';

void main() {
  testWidgets('renderiza secciones y tabla de precios', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const ServiciosComputadoresBogotaApp());

    expect(find.text('Soporte Técnico en Bogotá'), findsOneWidget);
    expect(find.text('Servicios'), findsOneWidget);
    expect(find.text('Tabla de precios de referencia'), findsOneWidget);
    expect(find.byType(DataTable), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}
