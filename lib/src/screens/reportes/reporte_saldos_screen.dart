import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movilcomercios/src/models/saldos/ultimas_solicitudes.dart';
import 'package:tuple/tuple.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../providers/reporte_saldo_provider.dart';
import '../../providers/shared_providers.dart';
import '../../providers/ultimas_solicitudes_provider.dart';


class ReporteSolicitudesScreen extends ConsumerWidget {

  const ReporteSolicitudesScreen({super.key});

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
    final data  = ref.watch(reporteSaldoListProvider(params));
    final router  = ref.watch(appRouteProvider);
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    return Scaffold(
      appBar: AppBar(
          title: const Text('Solicitudes de saldo.'),
          leading: IconButton(
              onPressed: (){
                router.go('/reportes');
              },
              icon: const Icon(Icons.arrow_back_ios))
      ),
      body: SizedBox(
        child: data.when(
            data: (data){
              List<UltimasSolicitudes> list  = data.map((e) => e).toList();
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
                                    _buildListItem('Transaccion',list[index].id.toString()),
                                    _buildListItem('Valor','\$${formatter.format(list[index].valor.toString())}'),
                                    _buildListItem('Metodo de pago',list[index].tipo_transaccion.toString()),
                                    if(list[index].fecha_aprobacion != null)
                                      _buildListItem('Aprobacion',formatDate(list[index].fecha_aprobacion.toString())),
                                    if(list[index].hora_aprobacion != null)
                                      _buildListItem('Hora',formatTime(list[index].hora_aprobacion.toString())),
                                    _buildListItem('Tipo de comision',list[index].tipoServicio.toString()),
                                    _buildListItem('Estado de solicitud',list[index].estado.toString()),
                                    _buildListItem('Estado de pago',list[index].estadoPago.toString()),
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