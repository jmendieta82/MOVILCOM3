import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';
import 'package:movilcomercios/src/models/categoria.dart';
import 'package:movilcomercios/src/models/ultimas_ventas.dart';
import 'package:movilcomercios/src/models/usuario_actual.dart';
import 'package:movilcomercios/src/providers/ultimas_ventas_provider.dart';
import '../providers/categoria_provider.dart';
import '../providers/login_provider.dart';

class CategoriaScreen extends ConsumerWidget {
  const CategoriaScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {

    return DefaultTabController(
      length: 2,
      child: Scaffold
        (appBar: AppBar(
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
        title: const Text("Categorias"),
      ),
        body: const SafeArea(
              child: Column(
                children: [
                  TabBar(tabs: [
                    Tab(text: 'Vender',),
                    Tab(text: 'Ultimas Ventas',),
                  ]),
                  Expanded(
                      child: TabBarView(
                          children: [
                            ListEmpresaView(),
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

class ListEmpresaView extends ConsumerWidget {
  const ListEmpresaView({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final data  = ref.watch(categoriaListProvider);
    final route  = ref.watch(appRouteProvider);
    
    return SizedBox(
      child: data.when(
          data: (data){
            List<Categoria> list  = data.map((e) => e).toList();
            return Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_,index){
                          return ListTile(
                            title: Text('${list[index].nombre}'),
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