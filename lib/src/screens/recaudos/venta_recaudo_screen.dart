import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:movilcomercios/src/internet_services/recaudos/consulta_convenios_conection.dart';
import 'package:movilcomercios/src/providers/lista_ventas_provider.dart';
import '../../app_router/app_router.dart';
import '../../providers/ventas_provider.dart';

class VentaRecaudoScreen extends ConsumerWidget {
  const VentaRecaudoScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    return const Scaffold(
      body: SafeArea(
        child: RecaudoView(),
      ),
    );
  }
}

class RecaudoView extends ConsumerWidget {
  const RecaudoView({
    super.key,
  });

  @override
  Widget build(BuildContext context,ref) {
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    TextEditingController valorVenta = TextEditingController();
    TextEditingController referencia = TextEditingController();
    TextEditingController telefono = TextEditingController();
    var phoneMask = MaskTextInputFormatter(
      mask: '(###) ###-####', // Máscara para el número de teléfono
      filter: {"#": RegExp(r'[0-9]')}, // Caracteres permitidos en la máscara
    );
    final empresaSeleccionada = ref.watch(empresaSeleccionadaProvider);
    final convenioSeleccionado = ref.watch(convenioSeleccionadoProvider);
    final route  = ref.watch(appRouteProvider);
    bool isTextFieldEnabled = true;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          empresaSeleccionada.nom_empresa.toString(),
          style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CircleAvatar(
            radius: 40,
            child: Image.asset(
              empresaSeleccionada.logo_empresa ?? '',
            ),
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  route.go('/convenios');
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      convenioSeleccionado.nombre != null?convenioSeleccionado.nombre.toString():'Toque aqui para seleccionar un convenio',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Referencia de pago', // Texto descriptivo o etiqueta
                      ),
                      style: const TextStyle(fontSize: 30),
                      controller: referencia,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox( // Añade un espacio entre la Card y el ListView
                      height: 20.0,
                    ),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: ElevatedButton(
                          onPressed:(){
                            if(convenioSeleccionado != null && referencia.text.isNotEmpty){
                              consultaReferencia(convenioSeleccionado.id.toString(), referencia.text).then((factura){
                                valorVenta.text = formatter.format(factura.valorPago.toString());
                                isTextFieldEnabled = factura.pagoParcial == 1?true:false;
                                ref.read(facturaSeleccionadaProvider.notifier).update((state) => factura);
                              });
                            }else {
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
                          },
                          child: const Text('Consultar')
                      ),
                    ),
                    TextField(
                      decoration:InputDecoration(
                        helperText:isTextFieldEnabled?'Si permite pago parcial':'Solo pago total',
                        helperStyle: const TextStyle(color: Colors.blueAccent),
                        labelText: 'Valor a pagar', // Texto descriptivo o etiqueta
                      ),
                      style: const TextStyle(fontSize: 30),
                      controller: valorVenta,
                      enabled: isTextFieldEnabled,
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Numero de telefono', // Texto descriptivo o etiqueta
                      ),
                      style: const TextStyle(fontSize: 30),
                      controller: telefono,
                      inputFormatters: [phoneMask],
                      keyboardType: TextInputType.number,
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
                              if( valorVenta.text.isNotEmpty && telefono.text.isNotEmpty){
                                  ref.read(valorSeleccionadoProvider.notifier).update((state) => int.parse(valorVenta.text.replaceAll('.', '')));
                                  ref.read(telefonoSeleccionadoProvider.notifier).update((state) => telefono.text);
                                  route.go('/confirm_venta_recaudo');
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
      ),
    );
  }
}



