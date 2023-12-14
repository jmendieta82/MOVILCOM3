import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_router/app_router.dart';

class ConstruccionView extends ConsumerWidget {
  const ConstruccionView({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final router = ref.watch(appRouteProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/nuevo_logo.png', // Ruta de tu imagen
              width: 200, // Ancho de la imagen
            ),
            const SizedBox(height: 20), // Espacio entre la imagen y el texto
            const Text(
              'Este recurso está en construcción.\nEstamos trabajando para brindarte el mejor servicio.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20), // Espacio entre el texto y el botón
            ElevatedButton(
              onPressed: () {
                router.go('/home');// Volver atrás al presionar el botón
              },
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}