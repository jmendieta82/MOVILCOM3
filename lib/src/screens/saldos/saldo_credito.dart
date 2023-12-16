import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/internet_services/saldos/solicitud_saldo_api_conection.dart';

import '../../app_router/app_router.dart';

class SolicitudCreditoScreen extends ConsumerStatefulWidget {
  const SolicitudCreditoScreen({super.key});
  @override
  ConsumerState createState() => _CreditRequestScreenState();
}

class _CreditRequestScreenState extends ConsumerState<SolicitudCreditoScreen> {
  @override
  Widget build(BuildContext context) {
    final route  = ref.watch(appRouteProvider);
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    TextEditingController valorRecarga = TextEditingController(
      text: formatter.format(ref.watch(valorSolicitudProvider))
    );
    final router = ref.watch(appRouteProvider);
    final metodoSeleccionado = ref.watch(metodoSeleccionadoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitud de Saldo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){route.go('/saldos');},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  TarjetaValorView(
                      color1: Color(0xFFB87333),
                      color2: Color(0xFFDAA520),
                      elevation: 2,
                      height: 200,
                      text: '\$20.000',
                      value : '20000'
                    ),
                  TarjetaValorView(
                    color1: Color(0xFFFFD700),
                    color2: Color(0xFFFFA500),
                    elevation: 6,
                    height: 220,
                    text: '\$100.000',
                    value : '100000'
                  ),
                  TarjetaValorView(
                    color1: Color(0xFFC0C0C0),
                    color2: Color(0xFFDCDCDC),
                    elevation: 2,
                    height: 200,
                    text: '\$50.000',
                    value : '50000'
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Selecciona el método de pago:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    const SelectMetodoPagoView(),
                    TextField(
                      style: const TextStyle(fontSize: 25),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      controller: valorRecarga,
                      decoration: const InputDecoration(
                        labelText: 'Valor',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () {
                  if(metodoSeleccionado == 'Contado'){
                    router.go('/image_soporte');
                  }else{
                    router.go('/resumen_solicitud');
                  }
                },
                child: const Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TarjetaValorView extends ConsumerWidget {
  final double elevation;
  final double height;
  final Color color1;
  final Color color2;
  final String text;
  final String value;

  const TarjetaValorView({
    Key? key,
    required this.elevation,
    required this.height,
    required this.color1,
    required this.color2,
    required this.text,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context,ref) {
    return Expanded(
              child: GestureDetector(
              onTap: (){
                  ref.read(valorSolicitudProvider.notifier).update((state) => value );
                },
              child: Card(
                elevation: elevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Stack(
                  children: <Widget>[
                    // Widget para la imagen centrada arriba
                    Container(
                      height: height,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [color1, color2],
                      ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Recargue ahora!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      ),
                    ),
                    Positioned(
                      top: height/3.8,
                      left: 2,
                      child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        'assets/gold.png',
                        fit: BoxFit.cover,
                        width: 95,
                        height: 95,
                      ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        'assets/nuevo_logo.png',
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class SelectMetodoPagoView extends ConsumerWidget {
  const SelectMetodoPagoView({super.key});
  @override
  Widget build(BuildContext context,ref) {
    final metodoSeleccionado  = ref.watch(metodoSeleccionadoProvider);
    final List<String> paymentTypes = ['Contado','Crédito'];
    return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Seleccionar'),
                    value: metodoSeleccionado, // Asigna la opción seleccionada
                    onChanged: (String? value) {
                        if (value != null) {
                          ref.read(metodoSeleccionadoProvider.notifier).update((state) => value);
                        }
                    },
                    items: paymentTypes.map((String paymentType) {
                    return DropdownMenuItem<String>(
                      value: paymentType,
                      child: Text(paymentType),
                    );
                    }).toList(),
                  ),
                ),
              );
  }
}




