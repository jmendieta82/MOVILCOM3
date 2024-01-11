import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';
import 'package:movilcomercios/src/providers/bolsa_provider.dart';
import 'package:movilcomercios/src/providers/ultimas_ventas_provider.dart';
import 'package:tuple/tuple.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../providers/ultimas_solicitudes_provider.dart';

class BolsaScreen extends ConsumerWidget {
  const BolsaScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final Tuple2 params = Tuple2(
        usuarioConectado.token.toString(),
        usuarioConectado.nodoId.toString(),
    );
    final bolsa = ref.watch(bolsaProvider(params));
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    final router = ref.watch(appRouteProvider);
    return Card( // Esta es la Card que se mostrará encima del ListView
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      elevation: 1,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
          child: bolsa.when(
              data:(data){
                final saldoDisponible = formatter.format(data.saldo_disponible.toString());
                final utilidad = formatter.format(data.utilidad.toString());
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        router.go('/saldos');
                      },
                      child: Column(
                            children: [
                              Text("\$$saldoDisponible",style: const
                              TextStyle(fontSize: 20,color: Color(0xFF182130),
                                fontWeight: FontWeight.bold
                              ),),
                              const Text('Disponible',style: TextStyle(fontSize: 13,color: Color(0xFF182130),)),
                            ],
                          ),
                    ),
                    IconButton(
                        onPressed:(){
                          ref.invalidate(bolsaProvider);
                          ref.invalidate(ultimasVentasListProvider);
                          ref.invalidate(ultimasSolicitudesListProvider);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Informacion actualizada.')),
                          );
                        },
                        icon:const Icon(Icons.refresh)),
                    Column(
                      children: [
                        Text("\$$utilidad",style: const TextStyle(fontSize: 20,color: Color(0xFF182130),
                            fontWeight: FontWeight.bold),),
                        const Text('Ganancias',style: TextStyle(fontSize: 13,color: Color(0xFF182130)),)
                      ],
                    ),
                  ],
                );
          },
          error: (err,s) => Text(err.toString()),
          loading:() => const Center(child: CircularProgressIndicator()))
      ),
    );
  }
}
