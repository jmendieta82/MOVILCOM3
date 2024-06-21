import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movilcomercios/src/internet_services/reportes/reporte_pagos_api_connection.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../providers/shared_providers.dart';
import '../common/custom_text_filed.dart';


class ReportePagosScreen extends ConsumerStatefulWidget {
  const ReportePagosScreen({super.key});

  @override
  ConsumerState createState() => _ReportePagosScreenState();
}

class _ReportePagosScreenState extends ConsumerState<ReportePagosScreen> {
  TextEditingController txtfInicio = TextEditingController();
  TextEditingController txtfFinal = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final router  = ref.watch(appRouteProvider);
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    Future<String?> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        locale: const Locale('es', 'ES'), // Establecer el idioma a español
      );
      if (picked != null) {
        return picked.toString().split(' ')[0];
      }
      return null;
    }
    final listaPagos = ref.watch(listaPagosProvider);
    bool isProgress = ref.watch(progressProvider);
    Future<void> fetchData() async {
      if(txtfInicio.text.isNotEmpty && txtfFinal.text.isNotEmpty){
        ref.read(progressProvider.notifier).update((state) => true);
        try {
          final value = await getReportePagos(usuarioConectado.token!, usuarioConectado.nodoId!, txtfInicio.text, txtfFinal.text);
          ref.read(progressProvider.notifier).update((state) => false);
          ref.read(listaPagosProvider.notifier).update((state) => value);

        } catch (error) {
          ref.read(progressProvider.notifier).update((state) => false);
          // Manejar el error si es necesario
          print(error.toString());
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleccione las dos fechas.'),
        ));
      }

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

    return Scaffold(
      appBar: AppBar(
          title: const Text('Reporte Pagos'),
          leading: IconButton(
              onPressed: (){router.go('/reportes');},
              icon: const Icon(Icons.arrow_back_ios))
      ),
      body: SizedBox(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MrnFieldBox(
                  controller: txtfInicio,
                  label: 'Fecha inicial',
                  kbType: TextInputType.text,
                  icon: IconButton(
                    icon: const Icon(Icons.calendar_month), // Icono que se muestra al final del TextField
                    onPressed: () async {
                      final selectedDate = await selectDate(context);
                      if (selectedDate != null) {
                        txtfInicio.text = selectedDate;
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MrnFieldBox(
                  controller: txtfFinal,
                  label: 'Fecha final',
                  kbType: TextInputType.text,
                  icon: IconButton(
                    icon: const Icon(Icons.calendar_month), // Icono que se muestra al final del TextField
                    onPressed: () async {
                      final selectedDate = await selectDate(context);
                      if (selectedDate != null) {
                        txtfFinal.text = selectedDate;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: ElevatedButton(
                    onPressed:fetchData,
                    child: const Text('Consultar')
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: ElevatedButton(
                    onPressed:(){
                      ref.read(listaPagosProvider.notifier).update((state) => []);
                      txtfInicio.text = '';
                      txtfFinal.text = '';
                    },
                    child: const Text('Limpiar')
                ),
              ),
              isProgress ? const Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Un momento por favor....')
                ],
              )) :
              Expanded(
                child: ListView.builder(
                  itemCount: listaPagos.length,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    final reportePago = listaPagos[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ExpansionTile(
                          title: _buildListItem('Transaccion', reportePago.transaccion.toString()),
                          subtitle: _buildListItem('Valor abono', '\$${formatter.format(reportePago.abono.toString())}'),
                          children: [
                            _buildListItem('Fecha', reportePago.created_at.toString()),
                            _buildListItem('Hora', extractTime(reportePago.hour_at.toString())),
                            _buildListItem('Valor factura', '\$${formatter.format(reportePago.valor.toString())}'),
                            _buildListItem('Valor abono', '\$${formatter.format(reportePago.abono.toString())}'),
                            _buildListItem('Saldo pendiente', '\$${formatter.format(reportePago.saldo_pendiente.toString())}'),
                            _buildListItem('Entidad', reportePago.entidad.toString()),
                            _buildListItem('Recibo', reportePago.numero_recibo.toString()),
                            _buildListItem('Estado', reportePago.estadoPago.toString()),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              ),
            ],
          )

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