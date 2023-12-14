import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/providers/ultimas_ventas_provider.dart';
import '../../app_router/app_router.dart';

class DetalleUltimasVentasScreen extends ConsumerWidget {
  const DetalleUltimasVentasScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final route  = ref.watch(appRouteProvider);
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    final transaccion = ref.watch(ultimaVentaSeleccionadaProvider);
    return Scaffold(
      appBar: AppBar(
        title:Text('Transaccion N. ${transaccion.id.toString()}'),

        actions: transaccion.imprime == true?
        const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.print),
          )
        ]:[],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildListItem('',transaccion.nomProducto.toString()),
                    _buildListItem('Codigo de aprobacion',transaccion.codigoTransaccionExterna.toString()),
                    _buildListItem('Venta desde',transaccion.ventaDesde.toString()),
                    _buildListItem('Operador',transaccion.nomEmpresa.toString()),
                    _buildListItem('Saldo anterior','\$${formatter.format(transaccion.ultimoSaldo.toString())}'),
                    _buildListItem('Valor venta','\$${formatter.format(transaccion.valor.toString())}'),
                    _buildListItem('Nuevo saldo','\$${formatter.format(transaccion.saldoActual.toString())}'),
                    _buildListItem('Ganancia','\$${formatter.format(transaccion.ganancia.toString())}'),
                    _buildListItem('Telefono',transaccion.numeroDestino.toString()),
                    _buildListItem('Codigo resultado',transaccion.codigoResultado.toString()),
                    _buildListItem('',transaccion.resultado.toString()),
                  ],
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: ElevatedButton(
                    onPressed:(){
                      route.go('/ultimas_ventas');
                    },
                    child: const Text('Volver')),
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