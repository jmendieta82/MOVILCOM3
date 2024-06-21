import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/internet_services/common/login_api_conection.dart';
import 'package:tuple/tuple.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/recargas/paquetes_api_connection.dart';
import '../../models/recargas/paquetes.dart';
import '../../providers/shared_providers.dart';
import '../common/custom_text_filed.dart';

TextEditingController numeroDestinoController = TextEditingController();


class RecargasPaquetesScreen extends ConsumerWidget {
  const RecargasPaquetesScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final empresaSeleccionada = ref.watch(empresaSeleccionadaProvider);
    final route  = ref.watch(appRouteProvider);
    final selectedTab = ref.watch(selectedTabProvider);
    return DefaultTabController(
      length: 2,
      initialIndex: selectedTab == 0?0:selectedTab,
      child: Scaffold(
        appBar: AppBar(
          leading: Row(
            children: [
              IconButton(
                  onPressed:(){
                    ref.read(selectedTabProvider.notifier).update((state) => 0);
                    route.go('/empresas');
                  },
                  icon: const Icon(Icons.arrow_back_ios)
              ),
            ],
          ) ,
          title: Text(empresaSeleccionada.nom_empresa.toString()),
        ),
        body: SafeArea(
          child: Column(
              children: [
                TabBar(
                    onTap: (index) {
                      // Aquí puedes agregar la lógica que deseas cuando se toca un tab
                     if(index == 1) {
                       route.go('/paquetes');
                       ref.read(fwdUrlImgProvider.notifier).update((state) => '/recargas_paquetes');
                     }
                     },
                    labelStyle: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: Colors.blueGrey.shade200,
                    tabs: const [
                      Tab(text: 'Recargas'),
                      Tab(text: 'Paquetes',),
                    ]),
                const Expanded(
                    child: TabBarView(
                        children: [
                          RecargasView(),
                          PaquetesView(),
                        ]
                    )
                )
              ],
          ),
        ),
      ),
    );
  }
}
class RecargasView extends ConsumerWidget {
  const RecargasView({
    super.key,
  });

  @override
  Widget build(BuildContext context,ref) {
    final empresaSeleccionada = ref.watch(empresaSeleccionadaProvider);
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final Tuple3 params = Tuple3(
        usuarioConectado.token.toString(),
        empresaSeleccionada.proveedor_id,
        empresaSeleccionada.empresa_id);
    final data = ref.watch(paquetesListProvider(params));
    TextEditingController valorVenta = TextEditingController();
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
     locale: 'es-Co', decimalDigits: 0,symbol: '',
   );
    final route  = ref.watch(appRouteProvider);


    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox( // Añade un espacio entre la Card y el ListView
                    height: 20.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ButtonBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButton( child: const Text('\$1.000'), onPressed: () {
                               valorVenta.text = formatter.format('1000');
                              }),
                              ElevatedButton( child: const Text('\$2.000'), onPressed: () {
                                valorVenta.text = formatter.format('2000');
                              }),
      
                          ],
                        ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton( child: const Text('\$5.000'), onPressed: () {
                            valorVenta.text = formatter.format('5000');
                          }),
                          ElevatedButton( child: const Text('\$10.000'), onPressed: () {
                            valorVenta.text = formatter.format('10000');
                          }),
      
                        ],
                      )
                    ],
                  ),
                  const SizedBox( // Añade un espacio entre la Card y el ListView
                    height: 20.0,
                  ),
                  MrnFieldBox(
                    label: 'Numero de telefono',
                    controller: numeroDestinoController,
                    kbType: TextInputType.number,
                    size: 25,
                    align: TextAlign.right,
                  ),
                  MrnFieldBox(
                    label: 'Valor de la recarga',
                    controller: valorVenta,
                    kbType: TextInputType.number,
                    formatters: [formatter],
                    size: 25,
                    align: TextAlign.right,
                  ),
                  const SizedBox( // Añade un espacio entre la Card y el ListView
                    height: 40.0,
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                          ),
                          child: const Text('Continuar'),
                          onPressed: () {
                            if( numeroDestinoController.text.isNotEmpty && valorVenta.text.isNotEmpty){
                                data.when(data: (data){
                                final Paquetes tiempoAire = data.where((element) => element.nomProducto == 'Tiempo al aire').first;
                                ref.read(paqueteSeleccionadoProvider.notifier).update((state) => tiempoAire);
                                ref.read(valorSeleccionadoProvider.notifier).update((state) => int.parse(valorVenta.text.replaceAll('.', '')));
                                ref.read(telefonoSeleccionadoProvider.notifier).update((state) => numeroDestinoController.text);
                                numeroDestinoController.clear();
                                route.go('/confirm_recargas_paquetes');
                                },error:(err,s) => print(err.toString()),loading: () =>{const CircularProgressIndicator()});
                            }
                            else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Datos incompletos'),
                                    content: const Text('Por favor, llene todos los datos.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Cierra el dialog
                                        },
                                        child: const Text('Ok entiendo!'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
      
                          }
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                          ),
                          child: const Text('Cancelar'),
                          onPressed: () {
                            ref.read(telefonoSeleccionadoProvider.notifier).update((state) => '');
                            numeroDestinoController.clear();
                            ref.read(selectedTabProvider.notifier).update((state) => 0);
                            route.go('/empresas');
                          },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class PaquetesView extends ConsumerWidget {
  const PaquetesView({
    super.key,
  });

  @override
  Widget build(BuildContext context,ref) {
    final paqueteSeleccionado = ref.watch(paqueteSeleccionadoProvider);
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    final route  = ref.watch(appRouteProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {route.go('/paquetes');},
              child: Text(
                textAlign: TextAlign.justify,
                paqueteSeleccionado.nomProducto != null?
                paqueteSeleccionado.nomProducto.toString():
                'Toque aqui para seleccionar un producto',
                style: const TextStyle(fontSize: 16,color: Colors.black54),
              ),
            )
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
             children: [
               Text('\$ ${formatter.format(paqueteSeleccionado.valorProducto.toString())}',
               style: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.black54),),
               MrnFieldBox(
                 label: 'Numero de telefono',
                 controller: numeroDestinoController,
                 kbType: TextInputType.number,
                 size: 25,
                 align: TextAlign.right,
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
                         textStyle: const TextStyle(fontSize: 20),
                       ),
                       child: const Text('Continuar'),
                       onPressed: () {
                         if( numeroDestinoController.text.isNotEmpty && paqueteSeleccionado.valorProducto != 0){
                           ref.read(telefonoSeleccionadoProvider.notifier).update((state) => numeroDestinoController.text);
                           ref.read(valorSeleccionadoProvider.notifier).update((state) => paqueteSeleccionado.valorProducto?? 0);
                           numeroDestinoController.clear();
                           route.go('/confirm_recargas_paquetes');
                         }
                         else {
                           showDialog(
                             context: context,
                             builder: (BuildContext context) {
                               return AlertDialog(
                                 title: const Text('Datos incompletos'),
                                 content: const Text('Por favor, llene todos los datos.'),
                                 actions: <Widget>[
                                   TextButton(
                                     onPressed: () {
                                       Navigator.of(context).pop(); // Cierra el dialog
                                     },
                                     child: const Text('Ok entiendo!'),
                                   ),
                                 ],
                               );
                             },
                           );
                         }

                       }
                   ),
                   TextButton(
                     style: TextButton.styleFrom(
                       padding: const EdgeInsets.all(16.0),
                       textStyle: const TextStyle(fontSize: 20),
                     ),
                     child: const Text('Cancelar'),
                     onPressed: () {
                       ref.read(telefonoSeleccionadoProvider.notifier).update((state) => '');
                       ref.read(valorSeleccionadoProvider.notifier).update((state) => 0);
                       ref.read(paqueteSeleccionadoProvider.notifier).update((state) => Paquetes());
                       numeroDestinoController.text = '';
                       route.go('/home');
                     },
                   ),
                 ],
               )
             ],
            ),
          )
        ],
      ),
    );
  }
}
