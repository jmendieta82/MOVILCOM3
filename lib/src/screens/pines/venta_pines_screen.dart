import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:movilcomercios/src/internet_services/common/login_api_conection.dart';
import 'package:tuple/tuple.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/recargas/paquetes_api_connection.dart';
import '../../models/recargas/paquetes.dart';
import '../../providers/shared_providers.dart';

class VentaPinesScreen extends ConsumerWidget {
  const VentaPinesScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: PinesView(),
        ),
      ),
    );
  }
}

class PinesView extends ConsumerWidget {
  const PinesView({
    super.key,
  });

  @override
  Widget build(BuildContext context,ref) {
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    final empresaSeleccionada = ref.watch(empresaSeleccionadaProvider);
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final paqueteSeleccionado = ref.watch(paqueteSeleccionadoProvider);
    final Tuple3 params = Tuple3(
        usuarioConectado.token.toString(),
        empresaSeleccionada.proveedor_id,
        empresaSeleccionada.empresa_id);
    final data = ref.watch(paquetesListProvider(params));
    TextEditingController valorVenta = TextEditingController(
     text: formatter.format(paqueteSeleccionado.valorProducto.toString())
   );
    TextEditingController email = TextEditingController();
    TextEditingController numeroDestino = TextEditingController();
    var phoneMask = MaskTextInputFormatter(
     mask: '(###) ###-####', // Máscara para el número de teléfono
     filter: {"#": RegExp(r'[0-9]')}, // Caracteres permitidos en la máscara
   );
   final route  = ref.watch(appRouteProvider);

    return SingleChildScrollView(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                route.go('/paquetes');
                ref.read(fwdUrlImgProvider.notifier).update((state) => '/pines');
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    paqueteSeleccionado.nomProducto != null?paqueteSeleccionado.nomProducto.toString():'Toque aqui para seleccionar un producto',
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 30.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Esta en venta', // Texto descriptivo o etiqueta
                    ),
                    style: const TextStyle(fontSize: 30),
                    inputFormatters: <TextInputFormatter>[formatter],
                    controller: valorVenta,
                    enabled: false,
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Correo electronico', // Texto descriptivo o etiqueta
                    ),
                    style: const TextStyle(fontSize: 30),
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Numero de telefono',
                    ),
                    style: const TextStyle(fontSize: 30),

                    keyboardType: TextInputType.phone,
                    inputFormatters: [phoneMask],
                    controller: numeroDestino,
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
                            if( email.text.isNotEmpty && numeroDestino.text.isNotEmpty && valorVenta.text.isNotEmpty){
                                data.when(data: (data){
                                ref.read(valorSeleccionadoProvider.notifier).update((state) => int.parse(valorVenta.text.replaceAll('.', '')));
                                ref.read(telefonoSeleccionadoProvider.notifier).update((state) => numeroDestino.text);
                                ref.read(emailSeleccionadoProvider.notifier).update((state) => email.text);
                                route.go('/confirm_venta_pines');
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
                      TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            textStyle: const TextStyle(fontSize: 20),
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

