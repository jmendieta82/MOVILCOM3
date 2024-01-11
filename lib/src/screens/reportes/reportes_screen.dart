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
    Future<String?> selectDate(BuildContext context) async {
      final picked = await DatePicker.showSimpleDatePicker(
      context,
      // initialDate: DateTime(2020),
      firstDate: DateTime(2020),
      lastDate: DateTime(2090),
      dateFormat: "dd-MMMM-yyyy",
      titleText: 'Seleccione una fecha',
      locale: DateTimePickerLocale.es,
      cancelText: 'Cancelar',
      looping: true,
      );
      if (picked != null) {
        return picked.toString().split(' ')[0];
      }
      return null;
    }
    final router  = ref.watch(appRouteProvider);
    TextEditingController fInicio = TextEditingController();
    TextEditingController fFinal = TextEditingController();


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
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Center(child: Icon(Icons.info)),
                    const SizedBox(width: 10),
                    Flexible( // Usamos Flexible para que el texto se ajuste al espacio disponible
                      child: RichText(
                        text: const TextSpan(
                          text: 'Para realizar una consulta por favor seleccione una fecha de inicio y una fecha de fin, enseguida seleccione el reporte que desee ver. ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF182130),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            MrnFieldBox(
              controller: fInicio,
              label: 'Fecha inicial',
              kbType: TextInputType.text,
              icon: IconButton(
                icon: const Icon(Icons.calendar_month), // Icono que se muestra al final del TextField
                onPressed: () async {
                  final selectedDate = await selectDate(context);
                  if (selectedDate != null) {
                    fInicio.text = selectedDate;
                    ref.read(fechaInicial.notifier).update((state) => selectedDate);
                  }
                },
              ),
            ),
            MrnFieldBox(
              controller: fFinal,
              label: 'Fecha final',
              kbType: TextInputType.text,
              icon: IconButton(
                icon: const Icon(Icons.calendar_month), // Icono que se muestra al final del TextField
                onPressed: () async {
                  final selectedDate = await selectDate(context);
                  if (selectedDate != null) {
                    fFinal.text = selectedDate;
                    ref.read(fechaFinal.notifier).update((state) => selectedDate);
                  }
                },
              ),
            ),
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
    final fInicial  = ref.watch(fechaInicial);
    final fFinal  = ref.watch(fechaFinal);
    return GestureDetector(
    onTap: () {
          if(titulo == 'Comisiones'){
            route.go(ruta);
          }else{
            if(fInicial.isNotEmpty && fFinal.isNotEmpty){
              route.go(ruta);
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Seleccione las dos fechas')),
              );
            }
          }
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
