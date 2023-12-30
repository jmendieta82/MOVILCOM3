
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
    final List<String> imageList = [
      'assets/banner1.png',
      'assets/banner2.png',
      'assets/banner3.png',
      'assets/banner4.png',
      // Agrega aquí tus URLs de imágenes
    ];
    final List<String> urls = [
      'https://mrncolombia.com/ofertas/',
      'https://mrncolombia.com/',
      'https://mrncolombia.com/trabaja-con-nosotros/',
      'https://mrncolombia.com/trabaja-con-nosotros/',
      // Agrega aquí las URLs correspondientes a cada imagen
    ];
    final List<String> cardTitles = [
      'Últimas ventas',
      'Saldos',
      'Reportes',
      'Mi Distribuidor',
      'MRN Colombia'
    ];
    final List<String> routes = [
      '/ultimas_ventas',
      '/saldos',
      '/construccion',
      '/construccion',
      '/about_us',
    ];
    final route  = ref.watch(appRouteProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold
        (
          extendBodyBehindAppBar: true, // Extiende el fondo detrás del AppBar
          extendBody: true, // Extiende el cuerpo de la Scaffold
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed:()async{
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
                  },
                  icon: const Icon(Icons.logout_outlined),)
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
          body: SafeArea(
            child: Column(
              children: [
                FutureBuilder<bool>(
                  future: DioClient.instance.checkInternetConnection(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Muestra un indicador de carga mientras se realiza la verificación de la conexión
                      return const SizedBox.shrink();//const LinearProgressIndicator();
                    } else {
                      if (snapshot.hasData && !snapshot.data!) {
                        // Muestra esto si la verificación de la conexión se completó y no hay conexión
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.yellow.shade100,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.error,
                                  size: 20, // Define el tamaño del icono aquí
                                ),
                              ),
                              Text(
                                'Se están usando datos patrocinados.',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // No muestra nada si hay conexión o si hay un error en la verificación
                        return const SizedBox.shrink();
                      }
                    }
                  },
                ),
                const SizedBox( // Añade un espacio entre la Card y el ListView
                  height: 10.0,
                ),
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
                const Expanded(
                    child: ListaVentasView(),
                ),
                /*Center(
                  child: CarouselSlider.builder(
                    itemCount: imageList.length,
                    options: CarouselOptions(
                      autoPlay: true, // Habilita el desplazamiento automático
                      aspectRatio: 16 / 9, // Proporción de aspecto de las imágenes
                      viewportFraction: 1, // Porción de la pantalla que ocupa cada imagen
                      enlargeCenterPage: true, // Agrandar la imagen en el centro
                      height: 150, // Ajusta la altura del carrusel aquí
                      autoPlayInterval: const Duration(seconds: 7),// Ajusta el intervalo aquí
                    ),
                    itemBuilder: (BuildContext context, int index, _) {
                      return GestureDetector(
                        onTap: () {
                          _launchURL(urls[index]);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.asset(
                            imageList[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),*/
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
/*Future<void> _launchURL(String url) async {
  if (await canLaunchUrl(url as Uri)) {
    await launchUrl(url as Uri);
  } else {
    throw 'Could not launch $url';
  }
}*/

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


