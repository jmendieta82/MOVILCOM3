
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';
import '../models/lista_ventas.dart';
import '../providers/lista_ventas_provider.dart';

class EmpresaScreen extends ConsumerWidget {
  const EmpresaScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final data = ref.watch(listaVentaListProvider);
    final router = ref.watch(appRouteProvider);
    final categoriaSeleccionada = ref.watch(categoriaSeleccionadaProvider);

    return Scaffold(
      appBar: AppBar(
      leading:IconButton(
          onPressed: (){
            router.go('/');
          },
          icon: const Icon(Icons.arrow_back_ios)
        ),
      title: Text(categoriaSeleccionada),
    ),
      body: data.when(
          data: (data){
            List<ListaVentas> list = data.where((element) => element.nom_categoria == categoriaSeleccionada).toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 1.0,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        ref.read(empresaSeleccionadaProvider.notifier).update((state) => state = item);
                        router.go('/recargas_paquetes');
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage(item.logo_empresa ?? ''),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          error: (err,s) => Text(err.toString()),
          loading: () => const Center(child: CircularProgressIndicator()))
    );
  }
}
