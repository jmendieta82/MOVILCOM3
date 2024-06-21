
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/internet_services/common/login_api_conection.dart';
import 'package:movilcomercios/src/providers/shared_providers.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/reportes/reporte_ventas_api_connection.dart';
import '../common/custom_text_filed.dart';


class ReporteVentasScreen extends ConsumerStatefulWidget {
  const ReporteVentasScreen({super.key});

  @override
  ConsumerState<ReporteVentasScreen> createState() => _ReporteVentasScreenState();
}

class _ReporteVentasScreenState extends ConsumerState<ReporteVentasScreen> {
  TextEditingController txtfInicio = TextEditingController();
  TextEditingController txtfFinal = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final router  = ref.watch(appRouteProvider);
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
    final tVentas = ref.watch(totalVentas);
    final tGanancias = ref.watch(totalGanancias);
    bool isProgress = ref.watch(progressProvider);
    Future<void> fetchData() async {
      if(txtfInicio.text.isNotEmpty && txtfFinal.text.isNotEmpty){
        ref.read(progressProvider.notifier).update((state) => true);
        try {
          final value = await getReporteVentas(usuarioConectado.token!, usuarioConectado.nodoId!, txtfInicio.text, txtfFinal.text);
          ref.read(progressProvider.notifier).update((state) => false);
          ref.read(totalVentas.notifier).update((state) => value.total_valor!);
          ref.read(totalGanancias.notifier).update((state) => value.total_ganancia!);

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
        title: const Text('Reporte Ventas'),
          leading: IconButton(
              onPressed: (){
                router.go('/reportes');
              },
              icon: const Icon(Icons.arrow_back_ios))
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children:[
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
                        ref.read(fechaInicial.notifier).update((state) => txtfInicio.text);
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
                        ref.read(fechaFinal.notifier).update((state) => txtfFinal.text);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              isProgress ? const Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Un momento por favor....')
                ],
              )) :
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
                      ref.read(totalVentas.notifier).update((state) => 0);
                      ref.read(totalGanancias.notifier).update((state) => 0);
                      txtfInicio.text = '';
                      txtfFinal.text = '';
                    },
                    child: const Text('Limpiar')
                ),
              ),
              const SizedBox(height: 20,),
              MenuCard(
                ruta: '/det_rep_ventas',
                titulo: '\$${formatter.format(tVentas.toString())}',
                subtitulo: 'Total ventas',
              ),
              const SizedBox(height: 10,),
              MenuCard(
                ruta: '/det_rep_ventas',
                titulo: '\$${formatter.format(tGanancias.toString())}',
                subtitulo: 'Total ganancias',
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
class MenuCard extends ConsumerWidget {
  final String titulo;
  final String subtitulo;
  final String ruta;

  const MenuCard({
    super.key,
    required this.ruta,
    required this.titulo,
    this.subtitulo = '',
  });

  @override
  Widget build(BuildContext context,ref) {
    final route  = ref.watch(appRouteProvider);
    return GestureDetector(
      onTap: () {
        print(titulo);
          if(titulo != '\$0'){
            route.go(ruta);
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Seleccione las dos fechas.')),
            );
          }
          },
      child: SizedBox(
        width: double.infinity, // Ocupar todo el ancho disponible
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF182130),
                  ),
                ),
                Text(
                  subtitulo,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF182130),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}