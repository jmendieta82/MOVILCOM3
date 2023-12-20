import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../internet_services/recargas/venta_api_conection.dart';
import '../../models/recargas/ws_recargas.dart';
import '../../providers/shared_providers.dart';


class ConfirmVentaPinesScreen extends ConsumerWidget {
  const ConfirmVentaPinesScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final empresaSeleccionada = ref.watch(empresaSeleccionadaProvider);
    final valorSeleccionado = ref.watch(valorSeleccionadoProvider);
    final telefonoSeleccionado = ref.watch(telefonoSeleccionadoProvider);
    final emailSeleccionado = ref.watch(emailSeleccionadoProvider);
    final paqueteSeleccionado = ref.watch(paqueteSeleccionadoProvider);
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final route  = ref.watch(appRouteProvider);
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );

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
                      ListTile(
                        title: Text(paqueteSeleccionado.nomProducto.toString(),
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20),
                          textAlign: TextAlign.justify,),
                        subtitle: const Text('Producto en venta',textAlign: TextAlign.right),
                      ),
                      ListTile(
                        title: Text(emailSeleccionado,
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              fontWeight:FontWeight.bold,
                              fontSize: 25),
                          textAlign: TextAlign.right,),
                        subtitle: const Text('Correo electronico',textAlign: TextAlign.right),
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
                  height: 40.0,
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                        ),
                        child: const Text('Vender con saldo'),
                        onPressed: () async {
                          final obj  = MSData(
                            nodo: usuarioConectado.nodoId.toString(),
                            usuario_mrn:usuarioConectado.id.toString(),
                            producto_venta:paqueteSeleccionado.id.toString(),
                            producto:paqueteSeleccionado.codigoProducto.toString(),
                            valor:paqueteSeleccionado.valorProducto != 0?paqueteSeleccionado.valorProducto:valorSeleccionado,
                            celular: telefonoSeleccionado.replaceAll(RegExp(r'[^0-9]'), ''),
                            emai: emailSeleccionado
                          );
                          ventaRecarga(obj).then((resultado) {
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
                                              if(resultado.codigo != '500'){
                                                ref.read(ventaResponseProvider.notifier).update((state) =>resultado.data!);
                                                route.go('/venta_pines_result');
                                              }else{
                                                route.go('/apuestas');
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
                            // Manejar los errores si ocurre algún problema con la petición
                            Text(error);
                          });
                        }
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                      ),
                      child: const Text('Vender con ganancias'),
                      onPressed: () {
                        final obj  = MSData(
                            nodo: usuarioConectado.nodoId.toString(),
                            usuario_mrn:usuarioConectado.id.toString(),
                            producto_venta:paqueteSeleccionado.id.toString(),
                            producto:paqueteSeleccionado.codigoProducto.toString(),
                            valor:paqueteSeleccionado.valorProducto != 0?paqueteSeleccionado.valorProducto:valorSeleccionado,
                            celular: telefonoSeleccionado.replaceAll(RegExp(r'[^0-9]'), ''),
                            emai: emailSeleccionado,
                            venta_ganancias: true
                        );
                        ventaRecarga(obj).then((resultado) {
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
                                            if(resultado.codigo != '500'){
                                              ref.read(ventaResponseProvider.notifier).update((state) =>resultado.data!);
                                              route.go('/venta_pines_result');
                                            }else{
                                              route.go('/apuestas');
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
                          // Manejar los errores si ocurre algún problema con la petición
                          Text(error);
                        });
                      },
                    ),
                  ],
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
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
