
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/screens/common/custom_text_filed.dart';
import 'package:tuple/tuple.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../models/common/ultimas_ventas.dart';
import '../../providers/shared_providers.dart';
import '../../providers/ultimas_ventas_provider.dart';

class ListUltimasVentasScreen extends ConsumerStatefulWidget {
  const ListUltimasVentasScreen({super.key});

  @override
  ConsumerState createState() => _ListUltimasVentasScreenState();
}

class _ListUltimasVentasScreenState extends ConsumerState<ListUltimasVentasScreen> {
  @override
  Widget build(BuildContext context) {
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    Tuple2 params = Tuple2(usuarioConectado.token, usuarioConectado.nodoId);
    final data  = ref.watch(ultimasVentasListProvider(params));
    final router  = ref.watch(appRouteProvider);
    print("Reconstruyendo el widget...");
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
              List<UltimasVentas> filteredList = list;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /*Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MrnFieldBox(
                      placeholder: 'Buscar por telefono',
                      kbType: TextInputType.number,
                      onValueChange: (value){
                        // Filtrar la lista original y almacenarla en la lista filtrada
                        setState(() {
                          filteredList = list.where((venta) {
                            return venta.numeroDestino!.contains(value);
                          }).toList();
                        });
                      },
                    ),
                  ),*/
                  Expanded(
                    child: ListView.builder(
                        itemCount: filteredList.length,
                        shrinkWrap: true,
                        itemBuilder: (_,index){
                          Icon buildIcon(String codigoResultado) {
                            return codigoResultado == '001' || codigoResultado == '00'
                                ? const Icon(Icons.check_circle, color: Colors.green)
                                : const Icon(Icons.close, color: Colors.red);
                          }
                          return ListTile(
                            leading:buildIcon(filteredList[index].codigoResultado.toString()),
                            title: Text('${filteredList[index].numeroDestino}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Fecha : ${filteredList[index].createdAt}'),
                                Text(
                                  'Venta desde : ${filteredList[index].ventaDesde}',
                                  style: TextStyle(
                                    color: filteredList[index].ventaDesde == 'Ganancias'?Colors.blue:
                                        Colors.orangeAccent
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios_outlined),
                            onTap: () {
                              ref.read(ultimaVentaSeleccionadaProvider.notifier).update((state) => filteredList[index]);
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
