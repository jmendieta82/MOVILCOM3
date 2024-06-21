import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_router/app_router.dart';
import '../../models/recargas/paquetes.dart';
import '../../providers/shared_providers.dart';
import 'package:intl/intl.dart';

class VentaApuestasResultScreen extends ConsumerWidget {
  const VentaApuestasResultScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    String formatDate(dateString) {
      final DateFormat inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');
      final DateFormat outputFormat = DateFormat('dd/MM/yyyy hh:mm a');
      final DateTime parsedDate = inputFormat.parse(dateString);
      final String formattedDate = outputFormat.format(parsedDate);
      return formattedDate;
    }
    final route  = ref.watch(appRouteProvider);
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    String extractTime(String dateTimeString) {
      // Convertir la cadena a un objeto DateTime
      DateTime fechaHora = DateTime.parse(dateTimeString);
      // Sumar 5 horas al objeto DateTime
      DateTime nuevaFechaHora = fechaHora.subtract(Duration(hours: 5));
      // Formatear la hora en el formato deseado (hh:mm:ss a)
      String horaFormateada = DateFormat('hh:mm:ss a').format(nuevaFechaHora);
      return horaFormateada;
    }
  final response = ref.watch(ventaResponseProvider);
    return Scaffold(
      appBar: AppBar(
        title:Center(
          child: Text(
              response.codigo_resultado == '001'?'Transaxion exitosa':'Transacción rechazada',
            style: TextStyle(color: response.codigo_resultado == '001'?Colors.green:Colors.red),
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text(response.id.toString(),textAlign: TextAlign.right),
                        subtitle: const Text('Transacción N°',textAlign: TextAlign.right),
                      ),
                      ListTile(
                        title: Text(extractTime(response.hour_at.toString()),textAlign: TextAlign.right),
                        subtitle: const Text('Fecha',textAlign: TextAlign.right),
                      ),
                      ListTile(
                        title: Text(response.numeroDestino.toString(),textAlign: TextAlign.right),
                        subtitle: const Text('Número celular',textAlign: TextAlign.right),
                      ),
                      ListTile(
                        title: Text(response.nom_producto.toString(),textAlign: TextAlign.right),
                        subtitle: const Text('Producto en venta',textAlign: TextAlign.right),
                      ),
                      ListTile(
                        title: Text(response.nombre_empresa.toString(),textAlign: TextAlign.right),
                        subtitle: const Text('Empresa',textAlign: TextAlign.right),
                      ),
                      ListTile(
                        title: Text('\$${formatter.format(response.valor.toString())}',textAlign: TextAlign.right),
                        subtitle: const Text('Valor venta',textAlign: TextAlign.right),
                      ),
                      ListTile(
                        title: Text(response.resultado.toString(),textAlign: TextAlign.right),
                        subtitle: const Text('Respuesta',textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: ElevatedButton(
                      onPressed:(){
                        ref.read(telefonoSeleccionadoProvider.notifier).update((state) => '');
                        ref.read(valorSeleccionadoProvider.notifier).update((state) => 0);
                        ref.read(documentoSeleccionadoProvider.notifier).update((state) => '');
                        ref.read(paqueteSeleccionadoProvider.notifier).update((state) => Paquetes());
                        route.go('/home');
                      },
                      child: const Text('Continuar')),
                )
              ],
            ),
          ),

      ),
    );
  }
}
