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
    String formatTime(dateString) {
      final DateFormat inputFormat = DateFormat('HH:mm:ss.SSSZ');
      final DateFormat outputFormat = DateFormat('hh:mm a');
      final DateTime parsedDate = inputFormat.parse(dateString);
      final String formattedTime = outputFormat.format(parsedDate);
      return formattedTime;
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
                        child: ExpansionTile(
                          title: _buildListItem('Transaccion',listaSolicitudes[index].id.toString()),
                          subtitle: _buildListItem('Valor','\$${formatter.format(listaSolicitudes[index].valor.toString())}'),
                          children: [
                            _buildListItem('Transaccion',listaSolicitudes[index].id.toString()),
                            _buildListItem('Valor','\$${formatter.format(listaSolicitudes[index].valor.toString())}'),
                            _buildListItem('Metodo de pago',listaSolicitudes[index].tipo_transaccion.toString()),
                            if(listaSolicitudes[index].fecha_aprobacion != null)
                              _buildListItem('Aprobacion',formatDate(listaSolicitudes[index].fecha_aprobacion.toString())),
                            if(listaSolicitudes[index].hora_aprobacion != null)
                              _buildListItem('Hora',formatTime(listaSolicitudes[index].hora_aprobacion.toString())),
                            _buildListItem('Tipo de comision',listaSolicitudes[index].tipoServicio.toString()),
                            _buildListItem('Estado de solicitud',listaSolicitudes[index].estado.toString()),
                            _buildListItem('Estado de pago',listaSolicitudes[index].estadoPago.toString()),
                          ],
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