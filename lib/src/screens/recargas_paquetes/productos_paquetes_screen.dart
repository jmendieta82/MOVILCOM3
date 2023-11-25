import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';
import 'package:movilcomercios/src/models/categoria.dart';
import 'package:movilcomercios/src/models/ultimas_ventas.dart';
import 'package:movilcomercios/src/models/usuario_actual.dart';
import 'package:movilcomercios/src/providers/ultimas_ventas_provider.dart';

class ProductosPaquetesScreen extends ConsumerWidget {
  const ProductosPaquetesScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {

    return DefaultTabController(
      length: 2,
      child: Scaffold
        (appBar: AppBar(
        title: const Text("Paquetes"),
      ),
          body: const SafeArea(
            child: Column(
              children: [
                ListPaquetesView(),
              ],
            ),
          )
      ),
    );
  }
}

class ListPaquetesView extends ConsumerWidget {

  const ListPaquetesView({super.key});

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