import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';

class InfoRecaudoScreen extends ConsumerWidget {
  final String imageUrl;

  const InfoRecaudoScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context,ref) {
    final router = ref.watch(appRouteProvider);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imageUrl,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: ElevatedButton(
                  child: const  Text('Entendido'),
                  onPressed: () {
                    router.go('/recaudos');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}