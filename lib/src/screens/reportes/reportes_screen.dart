import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_router/app_router.dart';
import '../../providers/shared_providers.dart';
import '../common/custom_text_filed.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class ReportesScreen extends ConsumerWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {

    final router  = ref.watch(appRouteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
          leading: IconButton(
              onPressed: (){
                router.go('/home');
              },
              icon: const Icon(Icons.arrow_back_ios))
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                  children:const [
                    MenuCard(
                      ruta: '/reporte_comisiones',
                      titulo: 'Comisiones',
                      icono: Icon(Icons.donut_small,size: 30,color: Color(0xFF182130),),
                    ),
                    MenuCard(
                      ruta: '/reporte_ventas',
                      titulo: 'Ventas',
                      icono: Icon(Icons.savings,size: 30,color: Color(0xFF182130),),
                    ),
                    MenuCard(
                      ruta: '/reporte_solicitudes',
                      titulo: 'Solicitudes de saldo',
                      icono: Icon(Icons.request_quote,size: 30,color: Color(0xFF182130),),
                    ),
                    MenuCard(
                      ruta: '/reporte_pagos',
                      titulo: 'Pagos de saldos',
                      icono: Icon(Icons.currency_exchange,size: 30,color: Color(0xFF182130),),
                    )
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends ConsumerWidget {
  final String titulo;
  final String subtitulo;
  final String ruta;
  final Icon icono;

  const MenuCard({
    super.key,
    required this.ruta,
    required this.titulo,
    this.subtitulo = '',
    required this.icono,
  });

  @override
  Widget build(BuildContext context,ref) {
    final route  = ref.watch(appRouteProvider);
    return GestureDetector(
    onTap: () {
          route.go(ruta);
      },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Center(child: icono),
                    const SizedBox(width: 10,),
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF182130),
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios_outlined),
              ],
            ),
          ),
        ),
      );
  }
}
