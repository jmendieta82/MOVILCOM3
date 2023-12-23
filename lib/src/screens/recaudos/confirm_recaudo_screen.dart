import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/internet_services/recaudos/consulta_convenios_conection.dart';
import 'package:movilcomercios/src/internet_services/common/login_api_conection.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/recargas/venta_api_conection.dart';
import '../../providers/shared_providers.dart';


class ConfirmVentaRecaudoScreen extends ConsumerWidget {
  const ConfirmVentaRecaudoScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final empresaSeleccionada = ref.watch(empresaSeleccionadaProvider);
    final valorSeleccionado = ref.watch(valorSeleccionadoProvider);
    final telefonoSeleccionado = ref.watch(telefonoSeleccionadoProvider);
    final facturaSeleccionada = ref.watch(facturaSeleccionadaProvider);
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final convenioSeleccionado = ref.watch(convenioSeleccionadoProvider);
    final route  = ref.watch(appRouteProvider);
    bool isProgress = ref.watch(progressProvider);
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
                        title: Text(facturaSeleccionada.referencia.toString(),
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              fontWeight:FontWeight.bold,
                              fontSize: 25),
                          textAlign: TextAlign.right,),
                        subtitle: const Text('Referencia',textAlign: TextAlign.right),
                      ),
                      ListTile(
                        title: Text(facturaSeleccionada.nconvenio.toString(),
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              fontWeight:FontWeight.bold,
                              fontSize: 25),
                          textAlign: TextAlign.right,),
                        subtitle: const Text('Convenio',textAlign: TextAlign.right),
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
                isProgress ? const Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('Un momento por favor....')
                  ],
                )) :
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                        ),
                        child: const Text('Vender con saldo'),
                        onPressed: () async {
                          final obj  ={
                            "idcomercio": '113935',
                            "claveventa": '1379',
                            "celular":telefonoSeleccionado.replaceAll(RegExp(r'[^0-9]'), ''),
                            "operador":"fc",
                            "valor":valorSeleccionado,
                            "jsonAdicional":{"idPre":facturaSeleccionada.idPre},
                            "idtrans":"1",
                            "end_point":"pracRec",
                            "venta_ganancias":false,
                            "nodo":usuarioConectado.nodoId,
                            "usuario_mrn":usuarioConectado.id,
                            "producto_venta":convenioSeleccionado.tipo == '0'?'667':'721',//TODO aqui implementar la venta con codigo de barras
                            "referencia":facturaSeleccionada.referencia,
                            "medioVenta":'Movil',
                            "tipo_datos":'Propios',
                            "tipo_red":'Wifi',
                            "app_ver":'3'
                          };
                          ref.read(progressProvider.notifier).update((state) => true);
                       ventaRecaudo(obj).then((resultado) {
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
                                                route.go('/venta_recaudos_result');
                                              }else{
                                                route.go('/recaudos');
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
                          }).catchError((error) {
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
                                              child: Text('$error'),
                                            ),
                                            const SizedBox( height: 20.0),
                                            ElevatedButton(
                                                onPressed: (){
                                                  route.go('/recaudos');
                                                },
                                                child: const Text('Aceptar'))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                          });
                        }
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                      ),
                      child: const Text('Vender con ganancias'),
                        onPressed: () async {
                          final obj  ={
                            "idcomercio": '113935',
                            "claveventa": '1379',
                            "celular":telefonoSeleccionado.replaceAll(RegExp(r'[^0-9]'), ''),
                            "operador":"fc",
                            "valor":valorSeleccionado,
                            "jsonAdicional":{"idPre":facturaSeleccionada.idPre},
                            "idtrans":"1",
                            "end_point":"pracRec",
                            "venta_ganancias":true,
                            "nodo":usuarioConectado.nodoId,
                            "usuario_mrn":usuarioConectado.id,
                            "producto_venta":convenioSeleccionado.tipo == '0'?'667':'721',//TODO aqui implementar la venta con codigo de barras
                            "referencia":facturaSeleccionada.referencia,
                            "medioVenta":'Movil',
                            "tipo_datos":'Propios',
                            "tipo_red":'Wifi',
                            "app_ver":'3'
                          };
                          ventaRecaudo(obj).then((resultado) {
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
                                                route.go('/venta_recaudos_result');
                                              }else{
                                                route.go('/recaudos');
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
                          }).catchError((error) {
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
                                          padding: const EdgeInsets.all(10),
                                          child: Text('$error'),
                                        ),
                                        const SizedBox( height: 20.0),
                                        ElevatedButton(
                                            onPressed: (){
                                              route.go('/recaudos');
                                            },
                                            child: const Text('Aceptar'))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            // Manejar los errores si ocurre algún problema con la petición
                          });
                        }
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
                          route.go('/recaudos');
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
