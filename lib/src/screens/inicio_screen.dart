import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';
import 'package:movilcomercios/src/models/lista_ventas.dart';
import 'package:movilcomercios/src/models/ultimas_ventas.dart';
import 'package:movilcomercios/src/models/usuario_actual.dart';
import 'package:movilcomercios/src/providers/ultimas_ventas_provider.dart';
import '../providers/lista_ventas_provider.dart';
import '../providers/login_provider.dart';

class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {

    return DefaultTabController(
      length: 2,
      child: Scaffold
        (
          extendBodyBehindAppBar: true, // Extiende el fondo detrás del AppBar
          extendBody: true, // Extiende el cuerpo de la Scaffold
          appBar: AppBar(
            backgroundColor: Colors.transparent, // Hace el fondo del AppBar transparente
            elevation: 0, // Quita la sombra del AppBar
            leading: IconButton(
              onPressed: (){
                final access = ref.watch(loginAccesProvider);
                access.when(
                    data: (data){
                      UsuarioActual usLocal = data;
                    },
                    error: (err,s) => Text(err.toString()),
                    loading: () => const Center(child: CircularProgressIndicator(),)
                );
              },
              icon: const Icon(Icons.key_outlined)),
            title: const Text(
              "MRN Colombia",
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight:FontWeight.bold,fontSize: 25),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                TabBar(
                    labelStyle: const TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: Colors.blueGrey.shade200,
                    tabs: const [
                      Tab(text: 'Vender'),
                      Tab(text: 'Ultimas Ventas',),
                    ]),
                const Expanded(
                    child: TabBarView(
                        children: [
                          ListaVentasView(),
                          ListUltimasVentasView(),
                        ]
                    )
                )
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
    final data  = ref.watch(listaVentaListProvider);
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
                  height: 50.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView(
                      children: categorias.keys.map((categoria) {
                        return Card(
                          child: ListTile(
                            trailing: const Icon(Icons.arrow_forward_rounded),
                            onTap: (){
                              ref.read(categoriaSeleccionadaProvider.notifier).update((state) => state = categoria);
                              route.go('/empresas');
                            } ,
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  categoria,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  )
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox( // Añade un espacio entre la Card y el ListView
                  height: 15.0,
                ),
                const Card( // Esta es la Card que se mostrará encima del ListView
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  elevation: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text("\$500.000",style: TextStyle(fontSize: 25),),
                              Text('Cupo disponible')
                            ],
                          ),
                        ),
                        Center(
                          child: Column(
                            children: [
                              Text("\$500.000",style: TextStyle(fontSize: 25),),
                              Text('Ganancias')
                            ],
                          ),
                        )
                      ],
                    )
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

class ListUltimasVentasView extends ConsumerWidget {

  const ListUltimasVentasView({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final data  = ref.watch(ultimasVentasListProvider);
    final route  = ref.watch(appRouteProvider);

    return SizedBox(
      child: data.when(
          data: (data){
            List<UltimasVentas> list  = data.map((e) => e).toList();
            return Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        shrinkWrap: true,
                        itemBuilder: (_,index){
                          return ListTile(
                            title: Text('Transaccion : ${list[index].id}'),
                            subtitle: Text('Fecha : ${list[index].createdAt}'),
                            trailing: const Icon(Icons.arrow_forward_ios_outlined),
                            onTap: () {
                              route.go('/empresas');
                            },
                          );
                        }
                    )
                )
              ],
            );
          },
          error: (err,s) => Text(err.toString()),
          loading: () => const Center(child: CircularProgressIndicator(),)),
    );
  }
}