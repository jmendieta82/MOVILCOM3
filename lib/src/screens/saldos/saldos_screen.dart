import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/providers/credito_provider.dart';
import 'package:movilcomercios/src/screens/common/footer_screen.dart';
import 'package:tuple/tuple.dart';

import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';

class Option {
  final String title;
  final VoidCallback onPressed;

  Option({required this.title, required this.onPressed});
}

class SaldosScreen extends ConsumerStatefulWidget {
  const SaldosScreen({super.key});

  @override
  ConsumerState createState() => _SaldosScreenState();
}

class _SaldosScreenState extends ConsumerState<SaldosScreen> {
  @override
  Widget build(BuildContext context) {
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    Tuple2 params = Tuple2(usuarioConectado.token, usuarioConectado.nodoId);
    final credito = ref.watch(creditoProvider(params));
    final route  = ref.watch(appRouteProvider);
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
          CardCarousel(),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 70.0),
                SizedBox(
                  height: 230, // Altura del SizedBox
                  width: 230, // Anchura del SizedBox
                  child: credito.when(
                      data: (data){
                        /*final double montoUtilizado = data.montoUtilizado as double;
                        final double montoDisponible = data.montoDisponible as double;
                        final double resultado = montoUtilizado/montoDisponible;
                        print(resultado);*/
                        return const CircularProgressIndicator(
                            value: 0.5, // Valor del 50%
                            backgroundColor: Colors.grey,
                            strokeWidth: 30, // Grosor de la línea
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue));
                      },
                      error: (err,s) => Text(err.toString()),
                      loading:() => const Center(child: CircularProgressIndicator()))
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: ListView(
                    children: [
                      _buildListItem('Credito utilizado','\$500.000',Colors.blue),
                      _buildListItem('Credito disponible','\$500.000',Colors.grey),
                      _buildListItem('Credito autorizado','\$500.000',Colors.green),

                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          const BolsaScreen(),
        ],
      )
    );
  }
}

class CardCarousel extends ConsumerWidget {
  final List<String> cardTitles = [
    'Solicitud de saldo',
    'Ultimas solicitudes',
    'Cartera'
  ];
  final List<String> route = [
    '/solicitud_credito',
    '/construccion',
    '/construccion',
  ];

  CardCarousel({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final router = ref.watch(appRouteProvider);
    return SizedBox(
      height: 60.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cardTitles.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              router.go(route[index]);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 160.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.blueGrey, // Color del borde
                    width: 2.0, // Ancho del borde
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10.0),
                      Text(
                        cardTitles[index],
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            ),
          );
        },
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