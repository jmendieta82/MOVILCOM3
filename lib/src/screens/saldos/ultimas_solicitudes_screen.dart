import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movilcomercios/src/models/saldos/ultimas_solicitudes.dart';
import 'package:tuple/tuple.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../providers/ultimas_solicitudes_provider.dart';


class UltimasSolicitudesScreen extends ConsumerWidget {

  const UltimasSolicitudesScreen({super.key});

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
    String extractTime(String dateTimeString) {
      // Convertir la cadena a un objeto DateTime
      DateTime fechaHora = DateTime.parse(dateTimeString);
      // Sumar 5 horas al objeto DateTime
      DateTime nuevaFechaHora = fechaHora.subtract(Duration(hours: 5));
      // Formatear la hora en el formato deseado (hh:mm:ss a)
      String horaFormateada = DateFormat('hh:mm:ss a').format(nuevaFechaHora);
      return horaFormateada;
    }
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    Tuple2 params = Tuple2(usuarioConectado.token, usuarioConectado.nodoId);
    final data  = ref.watch(ultimasSolicitudesListProvider(params));
    final router  = ref.watch(appRouteProvider);
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    return Scaffold(
      appBar: AppBar(
          title: const Text('Ultimas solicitudes.'),
          leading: IconButton(
              onPressed: (){
                router.go('/saldos');
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
                              color: list[index].estado == 'Rechazado' || list[index].estado == 'Anulado'?Colors.red[100]:null,
                              child: ListTile(
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildListItem('Transaccion',list[index].id.toString()),
                                    _buildListItem('Saldo antes','\$${formatter.format(list[index].ultimoSaldo.toString())}'),
                                    _buildListItem('Valor','\$${formatter.format(list[index].valor.toString())}'),
                                    _buildListItem('Saldo despues','\$${formatter.format(list[index].saldo_actual.toString())}'),
                                    _buildListItem('Metodo de pago',list[index].tipo_transaccion.toString()),
                                    _buildListItem('Fecha',formatDate(list[index].created_at.toString())),
                                    _buildListItem('Hora',extractTime(list[index].hour_at.toString())),
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