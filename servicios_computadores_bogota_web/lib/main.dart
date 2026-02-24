import 'package:flutter/material.dart';

void main() {
  runApp(const ServiciosComputadoresBogotaApp());
}

class ServiciosComputadoresBogotaApp extends StatelessWidget {
  const ServiciosComputadoresBogotaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Servicios de Computadores Bogotá',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A4F8F)),
        useMaterial3: true,
      ),
      home: const LandingServiciosPage(),
    );
  }
}

class LandingServiciosPage extends StatelessWidget {
  const LandingServiciosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soporte Técnico en Bogotá'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Mantenimiento, reparación y asesoría para computadores',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Atendemos equipos de escritorio y portátiles en Bogotá para hogares, '
              'estudiantes y pequeñas empresas. Servicio presencial y remoto.',
            ),
            const SizedBox(height: 28),
            Text(
              'Servicios',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const _ServicioCard(
              icono: Icons.cleaning_services_outlined,
              titulo: 'Mantenimiento preventivo',
              descripcion:
                  'Limpieza interna, revisión de temperatura, optimización del sistema '
                  'y actualización de software para mayor rendimiento.',
            ),
            const _ServicioCard(
              icono: Icons.settings_suggest_outlined,
              titulo: 'Reparación correctiva',
              descripcion:
                  'Diagnóstico y solución de fallas de hardware y software: disco, memoria, '
                  'sistema operativo, virus y errores de arranque.',
            ),
            const _ServicioCard(
              icono: Icons.record_voice_over_outlined,
              titulo: 'Asesoría tecnológica',
              descripcion:
                  'Recomendaciones para compra de equipos, ampliaciones, copias de seguridad '
                  'y buenas prácticas de ciberseguridad.',
            ),
            const SizedBox(height: 28),
            Text(
              'Tabla de precios de referencia',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('Servicio')),
                  DataColumn(label: Text('Incluye')),
                  DataColumn(label: Text('Precio (COP)')),
                ],
                rows: const <DataRow>[
                  DataRow(cells: <DataCell>[
                    DataCell(Text('Mantenimiento básico')),
                    DataCell(Text('Limpieza + optimización general')),
                    DataCell(Text('\$80.000')),
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('Mantenimiento avanzado')),
                    DataCell(Text('Cambio de pasta térmica + diagnóstico completo')),
                    DataCell(Text('\$150.000')),
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('Reparación de software')),
                    DataCell(Text('Formateo, instalación y configuración inicial')),
                    DataCell(Text('\$120.000')),
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('Reparación de hardware')),
                    DataCell(Text('Mano de obra (sin repuestos)')),
                    DataCell(Text('Desde \$180.000')),
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('Asesoría personalizada')),
                    DataCell(Text('Sesión de 60 minutos')),
                    DataCell(Text('\$70.000')),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicioCard extends StatelessWidget {
  const _ServicioCard({
    required this.icono,
    required this.titulo,
    required this.descripcion,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icono),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(descripcion),
      ),
    );
  }
}
