
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';
import 'package:movilcomercios/src/models/common/lista_ventas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../internet_services/dio/dio_client.dart';
import '../../providers/lista_ventas_provider.dart';
import '../../providers/shared_providers.dart';
import 'footer_screen.dart';
import 'menu.dart';

class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final route  = ref.watch(appRouteProvider);
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold
        (
          extendBodyBehindAppBar: true, // Extiende el fondo detrás del AppBar
          extendBody: true, // Extiende el cuerpo de la Scaffold
          appBar: AppBar(
            actions: [
              PopupMenuButton<String>(
                onSelected: (String choice) {
                  // Maneja la opción seleccionada
                  switch (choice){
                    case 'ventas':
                      route.go('/ultimas_ventas');
                      break;
                    case 'saldos':
                      route.go('/saldos');
                      break;
                    case 'reportes':
                      route.go('/reportes');
                      break;
                    case 'distribuidor':
                      route.go('/construccion');
                      break;
                    case 'usuario':
                      route.go('/perfil_usuario');
                      break;
                    case 'nosotros':
                      route.go('/about_us');
                      break;
                    case 'salir':
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Cerrar sesión'),
                            content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Cierra el diálogo
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('username', '');
                                  prefs.setString('password', '');
                                  route.go('/');
                                  Navigator.of(context).pop(); // Cierra el diálogo
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        },
                      );
                      break;
                  }
                },
                icon: const Icon(Icons.menu), // Cambia el ícono por el que desees
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'usuario',
                      child: Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 10),
                          Text(usuarioConectado.username.toString()),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'ventas',
                      child: Row(
                        children: [
                          Icon(Icons.list),
                          SizedBox(width: 10),
                          Text('Ultimas ventas'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'saldos',
                      child: Row(
                        children: [
                          Icon(Icons.monetization_on),
                          SizedBox(width: 10),
                          Text('Solicitud de saldo'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'reportes',
                      child: Row(
                        children: [
                          Icon(Icons.query_stats),
                          SizedBox(width: 10),
                          Text('Reportes'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'distribuidor',
                      child: Row(
                        children: [
                          Icon(Icons.diversity_3),
                          SizedBox(width: 10),
                          Text('Mi distribuidor'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'nosotros',
                      child: Row(
                        children: [
                          Icon(Icons.face),
                          SizedBox(width: 10),
                          Text('MRN Colombia'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'salir',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 10),
                          Text('Salir'),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
            backgroundColor: Colors.transparent, // Hace el fondo del AppBar transparente
            elevation: 0, // Quita la sombra del AppBar
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 80, // Altura deseada
                width: 80, // Anchura deseada
                child: Image(
                  image: AssetImage('assets/nuevo_logo.png'),
                ),
              ),
            ),
          ),
          body:const SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: ListaVentasView(),
                ),
                SizedBox( // Añade un espacio entre la Card y el ListView
                  height: 15.0,
                ),
                BolsaScreen(),
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
                  height: 10.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GridView.count(
                      crossAxisCount: 2, // Número de elementos en cada fila
                      mainAxisSpacing: 10.0, // Espacio vertical entre las tarjetas
                      crossAxisSpacing: 5.0, // Espacio horizontal entre las tarjetas
                      children: categorias.keys.map((categoria) {
                        return GestureDetector(
                          onTap: () {
                            ref.read(categoriaSeleccionadaProvider.notifier).update((state) => state = categoria);
                            route.go('/empresas');
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(width: 10), // Espacio entre la imagen y el texto
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 70, // Ajusta el ancho de la imagen según tus necesidades
                                          height: 70, // Ajusta la altura de la imagen según tus necesidades
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage('assets/${categorias[categoria]?[0].img_categoria}'),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        categoria=='Recargas y Paquetes'?'Recargas':categoria,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF182130),
                                        ),
                                      ),
                                      Text(
                                        '${categorias[categoria]?.length} empresas',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF182130),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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


