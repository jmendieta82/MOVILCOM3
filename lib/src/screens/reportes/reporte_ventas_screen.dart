
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/internet_services/common/login_api_conection.dart';
import 'package:movilcomercios/src/providers/shared_providers.dart';
import 'package:tuple/tuple.dart';
import '../../app_router/app_router.dart';
import '../../providers/reporte_ventas_provider.dart';


class ReporteVentasScreen extends ConsumerStatefulWidget {
  const ReporteVentasScreen({super.key});

  @override
  ConsumerState<ReporteVentasScreen> createState() => _ReporteVentasScreenState();
}

class _ReporteVentasScreenState extends ConsumerState<ReporteVentasScreen> {
  @override
  Widget build(BuildContext context) {
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final fInicial = ref.watch(fechaInicial);
    final fFinal = ref.watch(fechaFinal);
    Tuple4 params = Tuple4(
        usuarioConectado.token,
        usuarioConectado.nodoId,
        fInicial,
        fFinal
    );
    final data = ref.watch(reporteVentasDataProvider(params));
    final router  = ref.watch(appRouteProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte Ventas'),
          leading: IconButton(
              onPressed: (){
                ref.invalidate(reporteVentasDataProvider);
                ref.read(fechaInicial.notifier).update((state) => '');
                ref.read(fechaFinal.notifier).update((state) => '');
                router.go('/reportes');
              },
              icon: const Icon(Icons.arrow_back_ios))
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: data.when(
          data: (data){
            return Column(
              children:[
                const SizedBox(height: 10,),
                MenuCard(
                  ruta: '/det_rep_ventas',
                  titulo: '\$${formatter.format(data.total_valor.toString())}',
                  subtitulo: 'Total ventas',
                ),
                const SizedBox(height: 10,),
                MenuCard(
                  ruta: '/det_rep_ventas',
                  titulo: '\$${formatter.format(data.total_ganancia.toString())}',
                  subtitulo: 'Total ganancias',
                ),
                const SizedBox(height: 10,),
              ],
            );
          },
          error: (err,s) => Text(err.toString()),
          loading: () => const Center(child: CircularProgressIndicator(),),
        )
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