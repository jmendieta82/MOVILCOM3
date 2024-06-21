import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movilcomercios/src/providers/shared_providers.dart';
import 'package:tuple/tuple.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../models/common/ultimas_ventas.dart';
import '../../providers/detalle_reporte_ventas_provider.dart';


class DetalleReporteVentasScreen extends ConsumerWidget {

  const DetalleReporteVentasScreen({super.key});

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
        fInicial,fFinal,
    );
    final data  = ref.watch(detalleReporteVentasListProvider(params));
    final router  = ref.watch(appRouteProvider);
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


    return Scaffold(
      appBar: AppBar(
          title: const Text('Detalle reporte de ventas'),
          leading: IconButton(
              onPressed: (){
                router.go('/reporte_ventas');
              },
              icon: const Icon(Icons.arrow_back_ios))
      ),
      body: SizedBox(
        child: data.when(
            data: (data){
              List<UltimasVentas> list  = data.map((e) => e).toList();
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
                              color:
                              list[index].codigoResultado.toString()=='00' ||
                                  list[index].codigoResultado.toString()=='001'?Colors.green[100]:Colors.red[100],
                              child: ListTile(
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildListItem('',list[index].nomProducto.toString()),
                                    _buildListItem('Codigo de aprobacion',list[index].codigoTransaccionExterna.toString()),
                                    _buildListItem('Venta desde',list[index].ventaDesde.toString()),
                                    _buildListItem('Fecha',list[index].createdAt.toString()),
                                    _buildListItem('hora',extractTime(list[index].hourAt.toString())),
                                    list[index].convenioPago == null?
                                    _buildListItem('Operador',list[index].nomEmpresa.toString())
                                        :_buildListItem('Convenio',list[index].convenioPago.toString()),
                                    _buildListItem('Saldo anterior','\$${formatter.format(list[index].ultimoSaldo.toString())}'),
                                    _buildListItem('Valor venta','\$${formatter.format(list[index].valor.toString())}'),
                                    _buildListItem('Nuevo saldo','\$${formatter.format(list[index].saldoActual.toString())}'),
                                    _buildListItem('Ganancia','\$${list[index].ganancia.toString()}'),
                                    _buildListItem('Telefono',list[index].numeroDestino.toString()),
                                    _buildListItem('Codigo resultado',list[index].codigoResultado.toString()),
                                    _buildListItem('',list[index].resultado.toString()),
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