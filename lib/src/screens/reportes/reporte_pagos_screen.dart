import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../models/reportes/reporte_pagos.dart';
import '../../providers/reporte_pagos_provider.dart';
import '../../providers/shared_providers.dart';


class ReportePagosScreen extends ConsumerWidget {

  const ReportePagosScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    String formatDate(dateString) {
      final DateFormat inputFormat = DateFormat('yyyy-MM-dd');
      final DateFormat outputFormat = DateFormat('dd/MM/yyyy');
      final DateTime parsedDate = inputFormat.parse(dateString);
      final String formattedDate = outputFormat.format(parsedDate);
      return formattedDate;
    }
    String formatTime(dateString) {
      final DateFormat inputFormat = DateFormat('HH:mm:ss.SSSZ');
      final DateFormat outputFormat = DateFormat('hh:mm a');
      final DateTime parsedDate = inputFormat.parse(dateString);
      final String formattedTime = outputFormat.format(parsedDate);
      return formattedTime;
    }
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final fInicial = ref.watch(fechaInicial);
    final fFinal = ref.watch(fechaFinal);
    Tuple4 params = Tuple4(
        usuarioConectado.token,
        usuarioConectado.nodoId,
        fInicial,
        fFinal
    );
    final data  = ref.watch(reportePagosListProvider(params));
    final router  = ref.watch(appRouteProvider);
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    return Scaffold(
      appBar: AppBar(
          title: const Text('Reporte Pagos'),
          leading: IconButton(
              onPressed: (){
                ref.invalidate(reportePagosListProvider);
                router.go('/reportes');
              },
              icon: const Icon(Icons.arrow_back_ios))
      ),
      body: SizedBox(
        child: data.when(
            data: (data){
              List<ReportePagos> list  = data.map((e) => e).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        shrinkWrap: true,
                        itemBuilder: (_,index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ListTile(
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildListItem('Transaccion',list[index].transaccion.toString()),
                                    _buildListItem('Fecha',list[index].created_at.toString()),
                                    _buildListItem('Valor factura','\$${formatter.format(list[index].valor.toString())}'),
                                    _buildListItem('Valor abono','\$${formatter.format(list[index].abono.toString())}'),
                                    _buildListItem('Saldo pendiente','\$${formatter.format(list[index].saldo_pendiente.toString())}'),
                                    _buildListItem('Entidad',list[index].entidad.toString()),
                                    _buildListItem('Recibo',list[index].numero_recibo.toString()),
                                    _buildListItem('Estado',list[index].estadoPago.toString()),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ],
              );
            },
            error: (err,s) => Text(err.toString()),
            loading: () => const Center(child: CircularProgressIndicator(),)),
      ),
    );
  }
}
Widget _buildListItem(String name, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (name.isNotEmpty)
        Expanded(
          flex: 3,
          child: Text(
            name,
            textAlign: TextAlign.start,
            style: const TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF182130)),
          ),
        ),
      const SizedBox(width: 8.0), // Ajusta el espacio entre los textos
      Expanded(
        flex: 2,
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: const TextStyle(color: Color(0xFF2863F1)),
        ),
      ),
    ],
  );
}