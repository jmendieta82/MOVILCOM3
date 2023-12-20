import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/recaudos/consulta_convenios_conection.dart';
import '../../models/recaudos/factura.dart';
import '../../providers/shared_providers.dart';
import 'package:intl/intl.dart';

class VentaRecaudosResultScreen extends ConsumerWidget {
  const VentaRecaudosResultScreen({super.key});

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
    final facturaSeleccionada = ref.watch(facturaSeleccionadaProvider);
  final response = ref.watch(ventaResponseProvider);
    return Scaffold(
      appBar: AppBar(
        title:Text(response.resultado.toString()),
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
                        title: Text(formatDate(response.hour_at),textAlign: TextAlign.right),
                        subtitle: const Text('Fecha',textAlign: TextAlign.right),
                      ),
                      ListTile(
                        title: Text(response.numeroDestino.toString(),textAlign: TextAlign.right),
                        subtitle: const Text('Número celular',textAlign: TextAlign.right),
                      ),
                      ListTile(
                        title: Text(facturaSeleccionada.nconvenio.toString(),textAlign: TextAlign.right),
                        subtitle: const Text('Convenio',textAlign: TextAlign.right),
                      ),
                      ListTile(
                        title: Text(facturaSeleccionada.referencia.toString(),textAlign: TextAlign.right),
                        subtitle: const Text('Referencia',textAlign: TextAlign.right),
                      ),
                      ListTile(
                        title: Text('\$${formatter.format(response.valor.toString())}',textAlign: TextAlign.right),
                        subtitle: const Text('Valor venta',textAlign: TextAlign.right),
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
                        ref.read(facturaSeleccionadaProvider.notifier).update((state) => FacturaReacudo());
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
