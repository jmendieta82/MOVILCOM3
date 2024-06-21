import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/providers/credito_provider.dart';
import 'package:movilcomercios/src/screens/common/footer_screen.dart';
import 'package:tuple/tuple.dart';

import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../common/menu.dart';

class SaldosScreen extends ConsumerStatefulWidget {
  const SaldosScreen({super.key});

  @override
  ConsumerState createState() => _SaldosScreenState();
}

class _SaldosScreenState extends ConsumerState<SaldosScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> cardTitles = [
      'Solicitud de saldo',
      'Ultimas solicitudes',
      'Cartera'
    ];
    final List<String> routes = [
      '/solicitud_credito',
      '/ultimas_solicitudes',
      '/cartera',
    ];
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    Tuple2 params = Tuple2(usuarioConectado.token, usuarioConectado.nodoId);
    final credito = ref.watch(creditoProvider(params));
    final route  = ref.watch(appRouteProvider);
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );

    return Scaffold(
      appBar: AppBar(
          title: const Text('Gestion de Saldos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){route.go('/home');},
        ),
      ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
                children:const [
                  MenuCard(
                    ruta: '/solicitud_credito',
                    titulo: 'Solicitud de saldo',
                    icono: Icon(Icons.donut_small,size: 30,color: Color(0xFF182130),),
                  ),
                  MenuCard(
                    ruta: '/ultimas_solicitudes',
                    titulo: 'Ultimas solicitudes',
                    icono: Icon(Icons.savings,size: 30,color: Color(0xFF182130),),
                  ),
                  MenuCard(
                    ruta: '/cartera',
                    titulo: 'Cartera',
                    icono: Icon(Icons.request_quote,size: 30,color: Color(0xFF182130),),
                  ),
                ]
            ),
          ),
          Expanded(
            child: credito.when(
                data:(data){
                  final double resultado = data.montoUtilizado!/data.montoAutorizado!;
                  return  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50.0),
                        LinearProgressIndicator(
                          value: resultado, // Valor de progreso actual
                          minHeight: 10, // Altura mínima del indicador
                          backgroundColor: Colors.green, // Color de fondo
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        const SizedBox(height: 10.0),
                        Expanded(
                          child: ListView(
                            children: [
                              _buildListItem('Monto autorizado','\$${formatter.format(data.montoAutorizado.toString())}',Colors.grey),
                              _buildListItem('Monto utilizado','\$${formatter.format(data.montoUtilizado.toString())}',Colors.blue),
                              _buildListItem('Monto disponible','\$${formatter.format(data.montoDisponible.toString())}',Colors.green),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                error: (err,s) => Text(err.toString()),
                loading:() => const Center(child: CircularProgressIndicator()))
          ),
          const SizedBox(height: 8.0),
          const BolsaScreen(),
        ],
      )
    );
  }
}
class MenuCard extends ConsumerWidget {
  final String titulo;
  final String subtitulo;
  final String ruta;
  final Icon icono;

  const MenuCard({
    super.key,
    required this.ruta,
    required this.titulo,
    this.subtitulo = '',
    required this.icono,
  });

  @override
  Widget build(BuildContext context,ref) {
    final route  = ref.watch(appRouteProvider);
    return GestureDetector(
      onTap: () {
        route.go(ruta);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Center(child: icono),
                  const SizedBox(width: 10,),
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF182130),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios_outlined),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildListItem(String name, String value,Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 20.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Icon(Icons.circle,color:color,)),
        Expanded(
          flex: 3,
          child: Text(
            name,
            textAlign: TextAlign.start,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8.0), // Ajusta el espacio entre los textos
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}