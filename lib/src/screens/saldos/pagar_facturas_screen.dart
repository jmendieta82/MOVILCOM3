import 'dart:convert';
import 'dart:io';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/internet_services/common/login_api_conection.dart';
import 'package:movilcomercios/src/internet_services/saldos/pagar_saldo_api_connection.dart';
import 'package:movilcomercios/src/internet_services/saldos/solicitud_saldo_api_conection.dart';
import '../../app_router/app_router.dart';
import '../../providers/cartera_provider.dart';
import '../../providers/credito_provider.dart';
import '../../providers/shared_providers.dart';
import '../common/custom_text_filed.dart';

class PagoFacturasScreen extends ConsumerStatefulWidget {
  const PagoFacturasScreen({super.key});

  @override
  ConsumerState createState() => _PagoFacturasScreenState();
}
class _PagoFacturasScreenState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    String? selectedEntity;
    List<String> entities = ['Efectivo','Bancolombia', 'Banco de Occidente', 'Banco agrario','Nequi','Efecty'];
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    final facturasSeleccionadas = ref.watch(facturasSeleccionadasProvider);
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final imagenSeleccionada = ref.watch(imagenProvider);
    final entidadSeleccionada = ref.watch(entidadSeleccionadaProvider);
    final imagen64Seleccionada = ref.watch(imagen64Provider);
    final router  = ref.watch(appRouteProvider);
    bool isProgress = ref.watch(progressProvider);
    final total = facturasSeleccionadas.fold(0, (previousValue, cartera) => previousValue + (cartera.valor ?? 0));
    final TextEditingController totalAbonoController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago de Facturas'),
          leading: IconButton(
              onPressed: (){
                router.go('/cartera');
              },
              icon: const Icon(Icons.arrow_back_ios))
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 90, // Establece una altura específica
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: facturasSeleccionadas.length,
                  itemBuilder: (_, index) {
                    return SizedBox(
                      width: 250, // Ancho fijo de la tarjeta
                      height: double.infinity, // Limita la altura de la tarjeta
                      child: Card(
                        child: ListTile(
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildListItem('Transaccion', facturasSeleccionadas[index].id.toString()),
                              _buildListItem('Saldo', '\$${formatter.format(facturasSeleccionadas[index].saldo_pendiente_pago.toString())}'),
                              _buildListItem('Fecha', facturasSeleccionadas[index].fecha_aprobacion.toString()),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Deslice para más facturas seleccionadas.',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Text('Total a pagar: \$${formatter.format(total.toString())}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(top: 20), // Margen superior de 20
                width: 100,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1), // Borde del contenedor
                ),
                child:Center(
                  child : imagenSeleccionada.isNotEmpty?
                  Image.file(
                      File(imagenSeleccionada),
                      width: double.infinity, // Ajusta la imagen al ancho del contenedor
                      height: double.infinity, // Ajusta la imagen al alto del contenedor
                      fit: BoxFit.contain, // Ajusta la imagen al tamaño del contenedor manteniendo la proporción
                  ):GestureDetector(
                    onTap: (){
                      ref.read(backUrlImgProvider.notifier).update((state) => '/pago_facturas');
                      ref.read(fwdUrlImgProvider.notifier).update((state) => '/pago_facturas');
                      router.go('/image_soporte');
                    },
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 50, // Tamaño del icono
                          color: Colors.grey, // Color del icono
                        ),
                        Text('Tomar foto de comprobante.',style: TextStyle(color: Colors.grey),)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if(imagenSeleccionada.isNotEmpty)
              GestureDetector(
                onTap: (){
                  ref.read(backUrlImgProvider.notifier).update((state) => '/pago_facturas');
                  ref.read(fwdUrlImgProvider.notifier).update((state) => '/pago_facturas');
                  router.go('/image_soporte');
                },
                child: const Icon(
                  Icons.flip_camera_ios_outlined,
                  size: 50, // Tamaño del icono
                  color: Colors.grey, // Color del icono
                ),
              ),
              const SizedBox(height: 20),
              /*DropdownButtonFormField<String>(
                value: selectedEntity,
                onChanged: (newValue) {
                  setState(() {
                    selectedEntity = newValue;
                    ref.read(entidadSeleccionadaProvider.notifier).update((state) => newValue.toString());
                  });
                },
                items: entities.map((entity) {
                  return DropdownMenuItem<String>(
                    value: entity,
                    child: Text(entity),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Entidad de recaudo',
                  border: OutlineInputBorder(),
                ),
              ),*/
              const SizedBox(height: 20),
              MrnFieldBox(
                label: 'Total abono',
                kbType: TextInputType.number,
                controller: totalAbonoController,
                formatters: [formatter],
                size: 25,
                align: TextAlign.right,
              ),
              const SizedBox(height: 20),
              isProgress ? const Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Un momento por favor....')
                ],
              )) :
              ElevatedButton(
                  onPressed:(){
                    final obj = {
                      'abono':int.parse(totalAbonoController.text.replaceAll('.', '')),
                      'facturas':jsonEncode(facturasSeleccionadas),
                      'usuario_id':usuarioConectado.id,
                      'soporte':imagen64Seleccionada,
                      'entidad':'Ninguna',
                      'app_ver':3,
                    };
                    if(totalAbonoController.text.isNotEmpty && imagen64Seleccionada.isNotEmpty){
                      ref.read(progressProvider.notifier).update((state) => true);
                      pagarSaldo(obj).then((respponse){
                        ref.read(progressProvider.notifier).update((state) => false);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('MRN Pagos'),
                              content:Text(respponse.mensaje.toString()),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: ()async {
                                    ref.read(imagenProvider.notifier).update((state) => '');
                                    ref.read(imagen64Provider.notifier).update((state) => '');
                                    ref.read(facturasSeleccionadasProvider.notifier).update((state) => []);
                                    ref.invalidate(carteraListProvider);
                                    ref.invalidate(creditoProvider);
                                    router.go('/cartera');
                                    Navigator.of(context).pop(); // Cierra el dialog
                                  },
                                  child: const Text('Ok entiendo!'),
                                ),
                              ],
                            );
                          },
                        );
                      });
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Faltan datos.')),
                      );
                    }
                  },
                  child: const Text('Pagar')
              )
            ],
          ),
        ),
      ),
    );
  }
}
Widget _buildListItem(String name, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (name.isNotEmpty)
        Expanded(
          flex: 3,
          child: Text(
            name,
            textAlign: TextAlign.start,
            style: const TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF182130)),
          ),
        ),
      const SizedBox(width: 8.0), // Ajusta el espacio entre los textos
      Expanded(
        flex: 2,
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: const TextStyle(color: Color(0xFF2863F1)),
        ),
      ),
    ],
  );
}