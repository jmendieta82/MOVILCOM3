
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../models/common/ultimas_ventas.dart';
import '../../providers/ultimas_ventas_provider.dart';

class ListUltimasVentasScreen extends ConsumerWidget {

  const ListUltimasVentasScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    Tuple2 params = Tuple2(usuarioConectado.token, usuarioConectado.nodoId);
    final data  = ref.watch(ultimasVentasListProvider(params));
    final router  = ref.watch(appRouteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ultimas ventas'),
        leading: IconButton(
            onPressed: (){
              router.go('/home');
            },
            icon: const Icon(Icons.arrow_back_ios))
      ),
      body: SizedBox(
        child: data.when(
            data: (data){
              List<UltimasVentas> list  = data.map((e) => e).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        shrinkWrap: true,
                        itemBuilder: (_,index){
                          Icon buildIcon(String codigoResultado) {
                            return codigoResultado == '001' || codigoResultado == '00'
                                ? const Icon(Icons.check_circle, color: Colors.green)
                                : const Icon(Icons.close, color: Colors.red);
                          }
                          return ListTile(
                            leading:buildIcon(list[index].codigoResultado.toString()),
                            title: Text('Transaccion : ${list[index].id}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Fecha : ${list[index].createdAt}'),
                                Text('Venta desde : ${list[index].ventaDesde}'),
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios_outlined),
                            onTap: () {
                              ref.read(ultimaVentaSeleccionadaProvider.notifier).update((state) => list[index]);
                              router.go('/detalle_ultima_venta');
                            },
                          );
                        }
                    ),
                  ),
                ],
              );
            },
            error: (err,s) => Text(err.toString()),
            loading: () => const Center(child: CircularProgressIndicator(),)),
      ),
    );
  }
}