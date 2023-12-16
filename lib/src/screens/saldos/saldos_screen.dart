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
          CardCarousel(cardTitles: cardTitles, route: routes,),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Deslice para más opciones',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Expanded(
            child: credito.when(
                data:(data){
                  final double resultado = data.montoUtilizado!/data.montoAutorizado!;
                  return  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 70.0),
                      SizedBox(
                        height: 230, // Altura del SizedBox
                        width: 230, // Anchura del SizedBox
                        child:CircularProgressIndicator(
                            value: resultado, // Valor del 50%
                            backgroundColor: Colors.grey,
                            strokeWidth: 30, // Grosor de la línea
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue)),
                      ),
                      const SizedBox(height: 50),
                      Expanded(
                        child: ListView(
                          children: [
                            _buildListItem('Monto utilizado','\$${formatter.format(data.montoUtilizado.toString())}',Colors.blue),
                            _buildListItem('Monto disponible','\$${formatter.format(data.montoDisponible.toString())}',Colors.grey),
                            _buildListItem('Monto autorizado','\$${formatter.format(data.montoAutorizado.toString())}',Colors.green),

                          ],
                        ),
                      ),
                    ],
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