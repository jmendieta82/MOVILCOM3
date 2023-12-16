import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_router/app_router.dart';

class AboutUsPage extends ConsumerWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final route  = ref.watch(appRouteProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de nosotros'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){route.go('/home');},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/nuevo_logo.png', // Ruta de tu imagen
              width: 200, // Ancho de la imagen
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Somos una empresa comprometida con el desarrollo, y crecimiento '
                    'sostenible en servicios de calidad, contamos con personal '
                    'altamente calificado en todas las áreas, dispuestos a '
                    'escuchar y a brindar siempre el mejor servicio a nuestros '
                    'clientes.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(), // Línea divisoria para separar contenido
            // Datos de contacto
            const SizedBox(height: 20),
            const Text(
              'Calle 15 # 23 -62 CentroOficina 202. Pasto, Nariño.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12,),
            ),
            const Text(
              'Correo electrónico: info@mrncolombia.com',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12,),
            ),
            const Text(
              'Línea Nacional: (602) 7212289.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12,),
            ),
            // Versión de la aplicación y derechos reservados
            const Spacer(),
            const Text(
              'Versión de la aplicación: 3.0.0',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              'Derechos reservados MRN Colombia',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}