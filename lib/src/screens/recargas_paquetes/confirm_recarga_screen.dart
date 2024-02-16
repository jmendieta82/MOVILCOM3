import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/internet_services/common/bolsa_api_connection.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../internet_services/recargas/venta_api_conection.dart';
import '../../models/recargas/ws_recargas.dart';
import '../../providers/shared_providers.dart';
import '../../providers/ultimas_ventas_provider.dart';


class ConfirmRecargasPaquetesScreen extends ConsumerWidget {
  const ConfirmRecargasPaquetesScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final empresaSeleccionada = ref.watch(empresaSeleccionadaProvider);
    final valorSeleccionado = ref.watch(valorSeleccionadoProvider);
    final telefonoSeleccionado = ref.watch(telefonoSeleccionadoProvider);
    final paqueteSeleccionado = ref.watch(paqueteSeleccionadoProvider);
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final route  = ref.watch(appRouteProvider);
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    bool isProgress = ref.watch(progressProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox( // Añade un espacio entre la Card y el ListView
                  height: 40.0,
                ),
                Card(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(empresaSeleccionada.logo_empresa ?? ''),
                    ),
                  ),
                  Text(
                    empresaSeleccionada.nom_empresa.toString(),
                    style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
                const SizedBox( // Añade un espacio entre la Card y el ListView
                  height: 40.0,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      if (paqueteSeleccionado.nomProducto != null)
                      ListTile(
                        title: Text(paqueteSeleccionado.nomProducto.toString(),
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20),
                          textAlign: TextAlign.justify,),
                        subtitle: const Text('Producto en venta',textAlign: TextAlign.right),
                      ),
                      ListTile(
                        title: Text(telefonoSeleccionado,
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              fontWeight:FontWeight.bold,
                              fontSize: 25),
                        textAlign: TextAlign.right,),
                        subtitle: const Text('Telefono',textAlign: TextAlign.right),
                      ),
                      ListTile(
                        title: Text(formatter.format(valorSeleccionado.toString()),
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight:FontWeight.bold,
                            fontSize: 25),
                            textAlign: TextAlign.right),
                        subtitle: const Text('Valor',textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                ),
                const SizedBox( // Añade un espacio entre la Card y el ListView
                  height: 20.0,
                ),
                isProgress ? const Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('Un momento por favor....')
                  ],
                )) :
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          backgroundColor: Colors.blueAccent
                      ),
                      child: const Text('Vender con saldo',style: TextStyle(color: Colors.white),),
                      onPressed: () async {
                        final obj  = MSData(
                          nodo: usuarioConectado.nodoId.toString(),
                          usuario_mrn:usuarioConectado.id.toString(),
                          producto_venta:paqueteSeleccionado.id.toString(),
                          producto:paqueteSeleccionado.codigoProducto.toString(),
                          valor:paqueteSeleccionado.valorProducto != 0?paqueteSeleccionado.valorProducto:valorSeleccionado,
                          celular: telefonoSeleccionado.replaceAll(RegExp(r'[^0-9]'), ''),
                        );
                        ref.read(progressProvider.notifier).update((state) => true);
                        ventaRecarga(obj).then((resultado) {
                          ref.read(progressProvider.notifier).update((state) => false);
                          showModalBottomSheet(
                            isDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 200,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 30),
                                        child: Text('${resultado.mensaje}'),
                                      ),
                                      const SizedBox( height: 20.0),
                                      ElevatedButton(
                                          onPressed: (){
                                            if(resultado.codigo != 500){
                                              ref.read(ventaResponseProvider.notifier).update((state) =>resultado.data!);
                                              ref.invalidate(bolsaActualProvider);
                                              ref.invalidate(ultimasVentasListProvider);
                                              route.go('/venta_result');
                                            }else{
                                              ref.invalidate(ultimasVentasListProvider);
                                              route.go('/recargas_paquetes');
                                            }
                                          },
                                          child: const Text('Aceptar'))
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          // Puedes realizar más operaciones con el resultado si es necesario
                        })
                            .catchError((error) {
                          ref.read(progressProvider.notifier).update((state) => false);
                          // Manejar los errores si ocurre algún problema con la petición
                          Text(error);
                        });
                      }
                  ),
                ),
                const SizedBox( // Añade un espacio entre la Card y el ListView
                  height: 20.0,
                ),
                isProgress ? const Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('Un momento por favor....')
                  ],
                )) :
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        backgroundColor: Colors.blueAccent
                    ),
                    child: const Text('Vender con ganancias',style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      final obj  = MSData(
                          nodo: usuarioConectado.nodoId.toString(),
                          usuario_mrn:usuarioConectado.id.toString(),
                          producto_venta:paqueteSeleccionado.id.toString(),
                          producto:paqueteSeleccionado.codigoProducto.toString(),
                          valor:paqueteSeleccionado.valorProducto != 0?paqueteSeleccionado.valorProducto:valorSeleccionado,
                          celular: telefonoSeleccionado.replaceAll(RegExp(r'[^0-9]'), ''),
                          venta_ganancias: true
                      );
                      ref.read(progressProvider.notifier).update((state) => true);
                      ventaRecarga(obj).then((resultado) {
                        ref.read(progressProvider.notifier).update((state) => false);
                        showModalBottomSheet(
                          isDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 30),
                                      child: Text('${resultado.mensaje}'),
                                    ),
                                    const SizedBox( height: 20.0),
                                    ElevatedButton(
                                        onPressed: (){
                                          if(resultado.codigo != 500){
                                            ref.read(ventaResponseProvider.notifier).update((state) =>resultado.data!);
                                            ref.invalidate(bolsaActualProvider);
                                            ref.invalidate(ultimasVentasListProvider);
                                            route.go('/venta_result');
                                          }else{
                                            ref.invalidate(ultimasVentasListProvider);
                                            route.go('/recargas_paquetes');
                                          }
                                        },
                                        child: const Text('Aceptar'))
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        // Puedes realizar más operaciones con el resultado si es necesario
                      })
                          .catchError((error) {
                        ref.read(progressProvider.notifier).update((state) => false);
                        // Manejar los errores si ocurre algún problema con la petición
                        Text(error);
                      });
                    },
                  ),
                ),
                const SizedBox( // Añade un espacio entre la Card y el ListView
                  height: 20.0,
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                        ),
                        child: const Text('Atras'),
                        onPressed: () {
                          route.go('/recargas_paquetes');
                        }
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
