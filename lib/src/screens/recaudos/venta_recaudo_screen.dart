import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:movilcomercios/src/internet_services/recaudos/consulta_convenios_conection.dart';
import 'package:movilcomercios/src/models/recaudos/factura.dart';
import 'package:movilcomercios/src/screens/common/custom_text_filed.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../models/recaudos/convenios.dart';
import '../../providers/shared_providers.dart';


class VentaRecaudoScreen extends ConsumerStatefulWidget {
  const VentaRecaudoScreen({super.key});

  @override
  ConsumerState createState() => _VentaRecaudoScreenState();
}

class _VentaRecaudoScreenState extends ConsumerState<VentaRecaudoScreen> {
  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      convenioSeleccionado.nombre != null?convenioSeleccionado.nombre.toString():'Toque aqui para seleccionar un convenio',
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: MyForm(),
            ),
          ],
        )
      ),
    );
  }
}

class MyForm extends ConsumerStatefulWidget {
  const MyForm({super.key});

  @override
  ConsumerState createState() => _MyFormState();
}

class _MyFormState extends ConsumerState<MyForm> {
  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
    locale: 'es-Co', decimalDigits: 0,symbol: '',
  );
  TextEditingController valorController = TextEditingController();
  TextEditingController referenciaController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  bool isTextFieldEnabled = true;
  final _formKey = GlobalKey<FormState>();
  String referencia = '';
  String telefono = '';


  consultarReferencia(Convenio convenio) {
    setState(() {
      if(convenio != null && referenciaController.text.isNotEmpty){
        ref.read(progressProvider.notifier).update((state) => true);
        consultaReferencia(convenio.id.toString(), referenciaController.text).then((factura){
          ref.read(progressProvider.notifier).update((state) => false);
          valorController.text = formatter.format(factura.valorPago.toString());
          isTextFieldEnabled = factura.pagoParcial == 1?true:false;
          ref.read(facturaSeleccionadaProvider.notifier).update((state) => factura);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(factura.reply.toString())),
          );
        }).catchError((error) {
          ref.read(progressProvider.notifier).update((state) => false);
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(error.toString())),
          );
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
    });
  }

  pagar(GoRouter router) {
    if (_formKey.currentState!.validate()) {
        ref.read(valorSeleccionadoProvider.notifier).update((state) => int.parse(valorController.text.replaceAll('.', '')));
        ref.read(telefonoSeleccionadoProvider.notifier).update((state) => telefonoController.text);
        router.go('/confirm_venta_recaudo');
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Llene todos los campos.')),
      );
    }
  }
  cancelar(GoRouter router){
    ref.read(valorSeleccionadoProvider.notifier).update((state) => 0);
    ref.read(telefonoSeleccionadoProvider.notifier).update((state) => '');
    ref.read(facturaSeleccionadaProvider.notifier).update((state) => FacturaReacudo());
    ref.read(convenioSeleccionadoProvider.notifier).update((state) => Convenio());
    ref.invalidate(conveniosListProvider);
    router.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final router  = ref.watch(appRouteProvider);
    final convenioSeleccionado = ref.watch(convenioSeleccionadoProvider);
    final facturaSeleccionada = ref.watch(facturaSeleccionadaProvider);
    bool isProgress = ref.watch(progressProvider);
    Future<void> scanBarcode() async {
      try {
        String barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', // Color del fondo de la pantalla de escaneo
          'Cancelar', // Texto del botón de cancelar
          true, // Muestra la linterna
          ScanMode.BARCODE, // Modo de escaneo: código de barras
        );

        if (barcode != '-1') {
          setState(() {
            referenciaController.text = barcode.toString();
          });
          //print('Código de barras escaneado: $barcode');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Escaneo cancelado.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al escanear el código de barras: $e')),
        );
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MrnFieldBox(
            label: 'Referencia',
            controller: referenciaController,
            kbType: TextInputType.number,
            onValue: (String value) {
              setState(() {
                referencia = value;
              });
            },
            icon: IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        width: 500, // Ajusta este valor según tus necesidades
                        height: 300, // Ajusta este valor según tus necesidades
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await scanBarcode();
                              },
                              child: const Text('Escanear código de barras'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20,),
          isProgress ? const Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text('Un momento por favor....')
            ],
          )) :
          FractionallySizedBox(
            widthFactor: 1,
            child: ElevatedButton(
              onPressed:() => consultarReferencia(convenioSeleccionado),
              child: const Text('Consultar'),
            ),
          ),
          const SizedBox(height: 20,),
          MrnFieldBox(
            label: 'Valor a pagar',
            controller: valorController,
            kbType: TextInputType.number,
            size: 25,
            enabled: facturaSeleccionada.pagoParcial == 1,
            align: TextAlign.right,
          ),
          Text(facturaSeleccionada.pagoParcial == 1?'Permite pago parcial':'Pago total',
          style: const TextStyle(color: Colors.redAccent)),
          const SizedBox(height: 20,),
          MrnFieldBox(
            label: 'Número de teléfono',
            kbType: TextInputType.number,
            controller: telefonoController,
            size: 25,
            align: TextAlign.right,
          ),
          const SizedBox(height: 30,),
          FractionallySizedBox(
            widthFactor: 1,
            child: ElevatedButton(
              onPressed:()=>  pagar(router),
              child: const Text('Continuar'),
            ),
          ),
          const SizedBox(height: 10,),
          FractionallySizedBox(
            widthFactor: 1,
            child: ElevatedButton(
              onPressed:()=> cancelar(router),
              child: const Text('Cancelar'),
            ),
          ),
        ],
      ),
    );
  }
}