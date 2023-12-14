import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/providers/bolsa_provider.dart';
import '../../internet_services/common/login_api_conection.dart';

class BolsaScreen extends ConsumerWidget {
  const BolsaScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    final bolsa = ref.watch(bolsaProvider(usuarioConectado.token.toString()));
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
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
                    Column(
                          children: [
                            Text("\$$saldoDisponible",style: const TextStyle(fontSize: 20,color: Colors.blueGrey),),
                            const Text('Cupo disponible',style: TextStyle(color: Colors.black45)),
                          ],
                        ),
                    Column(
                      children: [
                        Text("\$$utilidad",style: const TextStyle(fontSize: 20,color: Colors.blueGrey),),
                        const Text('Ganancias',style: TextStyle(color: Colors.black45),)
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
