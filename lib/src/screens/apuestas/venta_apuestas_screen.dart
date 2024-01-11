import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:movilcomercios/src/internet_services/common/login_api_conection.dart';
import 'package:tuple/tuple.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/recargas/paquetes_api_connection.dart';
import '../../models/recargas/paquetes.dart';
import '../../providers/shared_providers.dart';
import '../common/custom_text_filed.dart';

class VentaApuestasScreen extends ConsumerWidget {
  const VentaApuestasScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final empresaSeleccionada = ref.watch(empresaSeleccionadaProvider);
    final route  = ref.watch(appRouteProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
                onPressed:(){
                  route.go('/empresas');
                },
                icon: const Icon(Icons.arrow_back_ios)
            ),
          ],
        ) ,
        title: Text(empresaSeleccionada.nom_empresa.toString()),
      ),
      body: const SafeArea(
        child: ApuestasView(),
      ),
    );
  }
}

class ApuestasView extends ConsumerStatefulWidget {
  const ApuestasView({super.key});

  @override
  ConsumerState createState() => _ApuestasViewState();
}

class _ApuestasViewState extends ConsumerState<ApuestasView> {
  @override
  Widget build(BuildContext context) {
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    final empresaSeleccionada = ref.watch(empresaSeleccionadaProvider);
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final paqueteSeleccionado = ref.watch(paqueteSeleccionadoProvider);
    TextEditingController valorVenta = TextEditingController(
        text: formatter.format(paqueteSeleccionado.valorProducto.toString())
    );
    TextEditingController documento = TextEditingController();
    TextEditingController numeroDestino = TextEditingController();
    final route  = ref.watch(appRouteProvider);
    final Tuple3 paramsPaquetes = Tuple3(
        usuarioConectado.token.toString(),
        empresaSeleccionada.proveedor_id,
        empresaSeleccionada.empresa_id);
    final data = ref.watch(paquetesListProvider(paramsPaquetes));

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 30.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MrnFieldBox(
                    label: 'Esta en venta',
                    controller: valorVenta,
                    kbType: TextInputType.number,
                    size: 25,
                    align: TextAlign.right,
                  ),
                  MrnFieldBox(
                    label: 'Numero de documento',
                    controller: documento,
                    kbType: TextInputType.number,
                    size: 25,
                    align: TextAlign.right,
                  ),
                  MrnFieldBox(
                    label: 'Numero de telefono',
                    controller: numeroDestino,
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
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                          ),
                          child: const Text('Continuar'),
                          onPressed: () {
                            data.when(
                                data: (data){
                                  Paquetes paqueteSeleccionado = data.first;
                                  ref.read(paqueteSeleccionadoProvider.notifier).update((state) => paqueteSeleccionado);
                                  if( documento.text.isNotEmpty && numeroDestino.text.isNotEmpty && valorVenta.text.isNotEmpty){

                                    ref.read(valorSeleccionadoProvider.notifier).update((state) => int.parse(valorVenta.text.replaceAll('.', '')));
                                    ref.read(telefonoSeleccionadoProvider.notifier).update((state) => numeroDestino.text);
                                    ref.read(documentoSeleccionadoProvider.notifier).update((state) => documento.text);
                                    route.go('/confirm_venta_apuestas');
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
                                },error: (err,s) => Text(err.toString()),
                                loading: () => const Center(child: CircularProgressIndicator(),));
                          }
                      ),
                      ElevatedButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                        ),
                        child: const Text('Cancelar'),
                        onPressed: () {
                          ref.read(telefonoSeleccionadoProvider.notifier).update((state) => '');
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


/*void _mostrarModal(BuildContext context, AsyncValue<List<Paquetes>> data,WidgetRef ref) {
  final empresaSeleccionada = ref.watch(empresaSeleccionadaProvider);

  showModalBottomSheet(
    isScrollControlled: true, // Muestra el modal en pantalla completa
    isDismissible: true, // Permite cerrar el modal tocando fuera de él
    context: context,
    builder: (BuildContext context) {
      return Column(
        children: [
          const SizedBox( // Añade un espacio entre la Card y el ListView
            height: 50.0,
          ),
          Card(
            elevation: 0,// Añade un espacio entre la Card y el ListView
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 CircleAvatar(
                   radius: 30,
                   backgroundImage: AssetImage(empresaSeleccionada.logo_empresa ?? ''),
                 ),
                 Text(empresaSeleccionada.nom_empresa.toString(),style: const TextStyle(fontSize: 20),),
                 IconButton(
                   icon: const Icon(Icons.close),
                   onPressed: () {
                     Navigator.of(context).pop(); // Cierra el modal al presionar el botón
                   },
                 ),
               ],
             ),
           ),
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
                                ref.read(paqueteSeleccionadoProvider.notifier).update((state) => list[index]);
                                Navigator.of(context).pop(); // Cierra el modal al presionar el botón
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
      );
    },
  );
}*/
