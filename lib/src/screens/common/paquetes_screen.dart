import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../internet_services/recargas/paquetes_api_connection.dart';
import '../../models/recargas/paquetes.dart';
import '../../providers/shared_providers.dart';

class PaquetesScreen extends ConsumerStatefulWidget {

  const PaquetesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _CustomModalState();
}

class _CustomModalState extends ConsumerState<PaquetesScreen> {
  @override
  Widget build(BuildContext context) {
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final empresaSeleccionada = ref.watch(empresaSeleccionadaProvider);
    final Tuple3 params = Tuple3(
      usuarioConectado.token.toString(),
      empresaSeleccionada.proveedor_id,
      empresaSeleccionada.empresa_id,
    );
    final data = ref.watch(paquetesListProvider(params));
    final route  = ref.watch(appRouteProvider);
    final fwdUrl = ref.watch(fwdUrlImgProvider);

    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          child: Image.asset(
            empresaSeleccionada.logo_empresa ?? '',
            fit: BoxFit.cover, // O el ajuste que desees
          ),
        ),
        actions: [
          IconButton(onPressed:(){route.go(fwdUrl);}, icon: const Icon(Icons.close_outlined))
        ],
        title: Text(
          empresaSeleccionada.nom_empresa.toString(),
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: data.when(
                data: (data){
                  List<Paquetes> list = data.where((element) => element.nomProducto != 'Tiempo al aire').toList();
                  return ListView.builder(
                      itemCount: list.length,
                      shrinkWrap: true,
                      itemBuilder: (_,index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              title: Text(list[index].nomProducto.toString()),
                              onTap: () {
                                ref.read(selectedTabProvider.notifier).update((state) => 1);
                                ref.read(paqueteSeleccionadoProvider.notifier).update((state) => list[index]);
                                route.go(fwdUrl); // Selecciona el producto y vuelve a la pantalla de donde se invoco
                              },
                            ),
                          ),
                        );
                      }
                  );
                },
                error: (err,s) => Text(err.toString()),
                loading: () => const Center(child: CircularProgressIndicator(),)),
          ),
        ],
      ),
    );
  }
}