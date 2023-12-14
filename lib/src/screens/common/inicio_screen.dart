import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';
import 'package:movilcomercios/src/models/common/lista_ventas.dart';
import 'package:movilcomercios/src/models/common/ultimas_ventas.dart';
import 'package:movilcomercios/src/providers/ultimas_ventas_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../providers/lista_ventas_provider.dart';
import 'footer_screen.dart';

class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final route  = ref.watch(appRouteProvider);
    SharedPreferences? _prefs;
    return DefaultTabController(
      length: 2,
      child: Scaffold
        (
          drawer: Drawer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30,left: 30),
                  width: 120, // Ancho deseado
                  height: 120, // Alto deseado
                  child: const Image(
                      image: AssetImage('assets/nuevo_logo.png'),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        onTap:()async{
                          route.go('/home');
                        },
                        title: const Text(
                            'Inicio',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            )
                        ),
                        leading: const Icon(Icons.home_outlined),
                      ),
                      ListTile(
                        onTap:()async{
                          route.go('/construccion');
                        },
                        title: const Text(
                            'Saldos',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            )
                        ),
                        leading: const Icon(Icons.money_outlined),
                      ),
                      ListTile(
                        onTap:()async{
                          route.go('/construccion');
                        },
                        title: const Text(
                            'Reportes',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            )
                        ),
                        leading: const Icon(Icons.bar_chart),
                      ),
                      ListTile(
                        onTap:()async{
                          route.go('/construccion');
                        },
                        title: const Text(
                            'Mi distribuidor',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            )
                        ),
                        leading: const Icon(Icons.people_alt),
                      ),
                      ListTile(
                        onTap:()async{
                          _prefs = await SharedPreferences.getInstance();
                          if(_prefs!=null){
                            _prefs!.setString('username', '');
                            _prefs!.setString('password', '');
                            route.go('/');
                          }
                      },
                        title: const Text(
                            'Cerrar sesion',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            )
                        ),
                        leading: const Icon(Icons.logout_outlined),
                      ),
                      const ListTile(
                        title: Text(
                            'MRN Recargas Version 3.0.0 beta',
                            style: TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          extendBodyBehindAppBar: true, // Extiende el fondo detrás del AppBar
          extendBody: true, // Extiende el cuerpo de la Scaffold
          appBar: AppBar(
            backgroundColor: Colors.transparent, // Hace el fondo del AppBar transparente
            elevation: 0, // Quita la sombra del AppBar
            title: const Column(
              children: [
                Text(
                  "MRN Recargas",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight:FontWeight.bold,fontSize: 25),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
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
                const Expanded(
                    child: ListaVentasView(),
                ),
                const SizedBox( // Añade un espacio entre la Card y el ListView
                  height: 15.0,
                ),
                const BolsaScreen(),
              ],
            ),
          )
      ),
    );
  }
}

class ListaVentasView extends ConsumerWidget {
  const ListaVentasView({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    Tuple2 params = Tuple2(usuarioConectado.token, usuarioConectado.nodoId);
    final data  = ref.watch(listaVentaListProvider(params));
    final route  = ref.watch(appRouteProvider);

    return SizedBox(
      child: data.when(
          data: (data){
            List<ListaVentas> list  = data.map((e) => e).toList();
            Map<String, List<ListaVentas>> categorias = {};
            for (var elemento in list) {
              String? categoria = elemento.nom_categoria;
              if (!categorias.containsKey(categoria)) {
                categorias[categoria!] = [];
              }
              categorias[categoria!]!.add(elemento);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox( // Añade un espacio entre la Card y el ListView
                  height: 30.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView(
                      children: categorias.keys.map((categoria) {
                        return ListTile(
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            ref.read(categoriaSeleccionadaProvider.notifier).update((state) => state = categoria);
                            route.go('/empresas');
                          } ,
                          title: Text(
                              categoria,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              )
                          ),
                          subtitle:Text(
                              '${categorias[categoria]?.length} empresas',
                              style: const TextStyle(
                                color: Colors.blueGrey,
                              ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
          error: (err,s) => Text(err.toString()),
          loading: () => const Center(child: CircularProgressIndicator(),)),
    );
  }
}

class CardCarousel extends ConsumerWidget {
  final List<String> cardTitles = ['Últimas ventas', 'Saldos', 'Reportes', 'Mi Distribuidor'];
  final List<List<Color>> cardGradients = [
    [Colors.blue, Colors.lightBlueAccent],
    [Colors.green, Colors.lightGreen],
    [Colors.orange, Colors.deepOrange],
    [Colors.teal, Colors.cyan],
  ];
  final List<String> route = [
    '/ultimas_ventas',
    '/saldos',
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
              child: CardItem(
                title: cardTitles[index],
                gradientColors: cardGradients[index],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final String title;
  final List<Color> gradientColors;

  const CardItem({super.key,
    required this.title,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.0,
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
              title,
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
    );
  }
}
