import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/venta_recarga_paquete.dart';
import 'package:movilcomercios/src/providers/recargas_paquetes_provider.dart';

import '../../app_router/app_router.dart';
import '../../internet_services/venta_api_conection.dart';
import '../../models/lista_ventas.dart';
import '../../providers/lista_ventas_provider.dart';

class ConfirmRecargasPaquetesScreen extends ConsumerWidget {
  const ConfirmRecargasPaquetesScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final empresaSeleccionada = ref.watch(empresaSeleccionadaProvider);
    final valorSeleccionado = ref.watch(valorSeleccionadoProvider);
    final telefonoSeleccionado = ref.watch(telefonoSeleccionadoProvider);
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
                          final objVenta = {
                            'nodo': '15',
                            'usuario_mrn':'15',
                            'producto_venta':'1',
                            'producto':'42',
                            'valor':1000,
                            'celular':'3178551266',
                            'canal_transaccion':'2',
                            'transaccion_externa':'0',
                            'documento':'1088310088',
                            'oficina':'',
                            'matricula':'',
                            'email':'',
                            'recargas_multiproducto':'1',
                            'token':'',
                            'nombre':'',
                            'cod_municipio':'',
                            'cant_sorteos':'0',
                            'cant_cartones':'0',
                            'bolsa_ganancia':'',
                            'venta_ganancias':false,
                            'medioVenta':'Movil',
                            'tipo_datos':'Propios',
                            'tipo_red':'Wifi',
                            'app_ver':'3'
                          };
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Realizando venta...'),
                                content: FutureBuilder(
                                  future: VentaApiConnection(obj: objVenta).ventaRecarga(),
                                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(), // Indicador de carga mientras espera la respuesta
                                      );
                                    } else {
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                        // Manejo de errores si ocurre algún problema con la petición
                                      } else {
                                        // Operación completada, muestra el resultado en un diálogo
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Resultado de la venta'),
                                              content: Text(snapshot.data.mensaje.toString()),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    ref.read(telefonoSeleccionadoProvider.notifier).update((state) => '');
                                                    ref.read(valorSeleccionadoProvider.notifier).update((state) => 0);
                                                    ref.read(empresaSeleccionadaProvider.notifier).update((state) => ListaVentas());
                                                    Navigator.of(context).pop(); // Cierra el popup
                                                  },
                                                  child: const Text('Cerrar'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        return Container(); // Puedes retornar un contenedor vacío aquí
                                      }
                                    }
                                  },
                                ),
                              );
                            },
                          );
                        }
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                      ),
                      child: const Text('Vender con ganancias'),
                      onPressed: () {
                        //TODO implementar venta con ganancias
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
                        child: const Text('Cancelar'),
                        onPressed: () {
                          ref.read(telefonoSeleccionadoProvider.notifier).update((
                              state) => '');
                          ref.read(valorSeleccionadoProvider.notifier).update((
                              state) => 0);
                          ref.read(empresaSeleccionadaProvider.notifier).update((
                              state) => ListaVentas());
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
