import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';
import 'package:movilcomercios/src/internet_services/common/login_api_conection.dart';
import 'package:movilcomercios/src/internet_services/saldos/solicitud_saldo_api_conection.dart';

import '../../internet_services/common/bolsa_api_connection.dart';
import '../../internet_services/saldos/credito_api_connection.dart';
import '../../providers/ultimas_solicitudes_provider.dart';

class ResumenSolicitudScreen extends ConsumerWidget {
  const ResumenSolicitudScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    final router = ref.watch(appRouteProvider);
    final metodoSeleccionado = ref.watch(metodoSeleccionadoProvider);
    final valorSeleccionado = ref.watch(valorSolicitudProvider);
    final imagen64Seleccionada = ref.watch(imagen64Provider);
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final respuestaSaldo = ref.watch(respuestaSaldoPovider);
    bool isProgress = ref.watch(progressProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitud de saldo'),
        leading: IconButton(
          onPressed: (){
            if(metodoSeleccionado == 'Contado'){
              router.go('/image_soporte');
            }else{
              router.go('/solicitud_credito');
            }
          },
          icon: const Icon(Icons.arrow_back_ios_outlined),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          _buildListItem('Valor de la solicitud','\$${formatter.format(valorSeleccionado.toString())}'),
                          _buildListItem('Metodo de pago',metodoSeleccionado.toString()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              respuestaSaldo!.isNotEmpty?
              // ignore: prefer_const_constructors
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //const Icon(Icons.check_circle_outline,size: 50,color: Colors.green, ),
                          const SizedBox(height: 10),
                          Text(respuestaSaldo[0],textAlign: TextAlign.center,style: const TextStyle(fontSize: 20),),
                          Text(respuestaSaldo[1]),
                          const SizedBox(height: 40),
                          TextButton(
                            onPressed: () {
                              ref.read(metodoSeleccionadoProvider.notifier).update((state) => 'Contado');
                              ref.read(valorSolicitudProvider.notifier).update((state) => '');
                              ref.read(imagenProvider.notifier).update((state) => '');
                              ref.read(imagen64Provider.notifier).update((state) => '');
                              ref.read(respuestaSaldoPovider.notifier).update((state) => []);
                              ref.invalidate(bolsaActualProvider);
                              ref.invalidate(ultimasSolicitudesListProvider);
                              ref.invalidate(creditoActualProvider);
                              router.go('/saldos');
                            },
                            child: const Text('Aceptar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ):
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
                    onPressed:(){
                      final obj = {
                        'usuario':usuarioConectado.id,
                        'nodo':usuarioConectado.nodoId,
                        'valor':int.parse(valorSeleccionado.replaceAll('.', '')),
                        'medioSolicitud':'App',
                        'tipo_transaccion':metodoSeleccionado=='Contado'?'SSC':'SSCR',
                        'saldo_pendiente_pago':metodoSeleccionado=='Contado'?'0':valorSeleccionado.replaceAll('.', ''),
                        'soporte':metodoSeleccionado=='Contado'?imagen64Seleccionada:'',
                      };
                      ref.read(progressProvider.notifier).update((state) => true);
                      solicitudSaldo(obj).then((response){
                        ref.read(progressProvider.notifier).update((state) => false);
                        ref.read(respuestaSaldoPovider.notifier).update((state) => response.mensaje);
                        final List list = [
                          response.mensaje?[0],
                          metodoSeleccionado == 'Credito'?'${response.mensaje?[1]}':''
                        ];
                        ref.read(respuestaSaldoPovider.notifier).update((state) => list);
                      });
                    },
                    child: const Text('Solicitar')),
              )
            ],
          ),
        ),

      ),
    );
  }
}
Widget _buildListItem(String name, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 20.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name.isNotEmpty)
          Expanded(
            flex: 3,
            child: Text(
              name,
              textAlign: TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        const SizedBox(width: 8.0), // Ajusta el espacio entre los textos
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}