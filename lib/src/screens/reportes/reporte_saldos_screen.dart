import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../internet_services/reportes/reporte_solicitudes_saldo_api_connection.dart';
import '../../providers/shared_providers.dart';
import '../common/custom_text_filed.dart';

class ReporteSolicitudesScreen extends ConsumerStatefulWidget {
  const ReporteSolicitudesScreen({super.key});

  @override
  ConsumerState createState() => _ReporteSolicitudesScreenState();
}

class _ReporteSolicitudesScreenState extends ConsumerState<ReporteSolicitudesScreen> {
  TextEditingController txtfInicio = TextEditingController();
  TextEditingController txtfFinal = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String formatDate(dateString) {
      final DateFormat inputFormat = DateFormat('yyyy-MM-dd');
      final DateFormat outputFormat = DateFormat('dd/MM/yyyy');
      final DateTime parsedDate = inputFormat.parse(dateString);
      final String formattedDate = outputFormat.format(parsedDate);
      return formattedDate;
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
    final listaSolicitudes = ref.watch(listaSolicitudesProvider);
    bool isProgress = ref.watch(progressProvider);
    Future<void> fetchData() async {
      if(txtfInicio.text.isNotEmpty && txtfFinal.text.isNotEmpty){
        ref.read(progressProvider.notifier).update((state) => true);
        try {
          final value = await getReporteSolicitudesList(usuarioConectado.token!, usuarioConectado.nodoId!, txtfInicio.text, txtfFinal.text);
          ref.read(progressProvider.notifier).update((state) => false);
          ref.read(listaSolicitudesProvider.notifier).update((state) => value);

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
    String obtenerEquivalente(String tipoTransaccion) {
      print(tipoTransaccion);
      final tipoTransaccionMap = {
        'SSCR': 'Solicitud contado',
        'SSC': 'Solicitud crédito',
        'AJS': 'Reversión',
        // Agrega otros tipos de transacción según sea necesario
      };

      return tipoTransaccionMap[tipoTransaccion] ?? 'Tipo no encontrado';
    }


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
                    ref.read(listaSolicitudesProvider.notifier).update((state) => []);
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
                  itemCount: listaSolicitudes.length,
                  shrinkWrap: true,
                  itemBuilder: (_,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: listaSolicitudes[index].estado.toString()=='Rechazado'?Colors.red[100]:Colors.green[100],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ExpansionTile(
                            title: _buildListItem(obtenerEquivalente(listaSolicitudes[index].tipo_transaccion.toString()),listaSolicitudes[index].id.toString()),
                            subtitle: Column(
                              children: [
                                _buildListItem('Valor','\$${formatter.format(listaSolicitudes[index].valor.toString())}'),
                                _buildListItem('Fecha', listaSolicitudes[index].created_at != null ? formatDate(listaSolicitudes[index].created_at.toString()) : 'Fecha no disponible'),
                              ],
                            ),
                            children: [
                              _buildListItem('Transaccion',listaSolicitudes[index].id.toString()),
                              _buildListItem('Valor','\$${formatter.format(listaSolicitudes[index].valor.toString())}'),
                              _buildListItem('Metodo de pago',listaSolicitudes[index].tipo_transaccion.toString()),
                              _buildListItem('Fecha',formatDate(listaSolicitudes[index].created_at.toString())),
                              _buildListItem('Hora', listaSolicitudes[index].hour_at != null ? extractTime(listaSolicitudes[index].hour_at.toString()) : 'hora no disponible'),
                              _buildListItem('Tipo de comision',listaSolicitudes[index].tipoServicio.toString()),
                              _buildListItem('Estado de solicitud',listaSolicitudes[index].estado.toString()),
                              _buildListItem('Estado de pago',listaSolicitudes[index].estadoPago.toString()),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),
          ],
        ),
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