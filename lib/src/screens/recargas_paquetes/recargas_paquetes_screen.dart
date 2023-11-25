import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:movilcomercios/src/providers/lista_ventas_provider.dart';
import '../../app_router/app_router.dart';
import '../../providers/recargas_paquetes_provider.dart';

class RecargasPaquetesScreen extends ConsumerWidget {
  const RecargasPaquetesScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
              children: [
                TabBar(
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
                          Column(),
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

   TextEditingController valorVenta = TextEditingController();
   TextEditingController numeroDestino = TextEditingController();
   final empresaSeleccionada = ref.watch(empresaSeleccionadaProvider);
   final telefonoSeleccionado = ref.watch(telefonoSeleccionadoProvider);
   final valorSeleccionado = ref.watch(valorSeleccionadoProvider);
   var phoneMask = MaskTextInputFormatter(
     mask: '(###) ###-####', // Máscara para el número de teléfono
     filter: {"#": RegExp(r'[0-9]')}, // Caracteres permitidos en la máscara
   );
   final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
     locale: 'es-Co', decimalDigits: 0,symbol: '',
   );
   final route  = ref.watch(appRouteProvider);

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
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
            TextField(
              decoration: const InputDecoration(
                labelText: 'Valor de la recarga', // Texto descriptivo o etiqueta
              ),
              style: const TextStyle(fontSize: 30),
              inputFormatters: <TextInputFormatter>[formatter],
              controller: valorVenta,
              keyboardType: TextInputType.number,
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
                      if( numeroDestino.text.isNotEmpty && valorVenta.text.isNotEmpty){
                        ref.read(valorSeleccionadoProvider.notifier).update((state) => int.parse(valorVenta.text.replaceAll('.', '')));
                        ref.read(telefonoSeleccionadoProvider.notifier).update((state) => numeroDestino.text);
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
                      route.go('/empresas');
                    },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
