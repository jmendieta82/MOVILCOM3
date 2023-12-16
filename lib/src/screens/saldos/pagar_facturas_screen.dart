import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_router/app_router.dart';
import '../../providers/cartera_provider.dart';

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
    final router  = ref.watch(appRouteProvider);
    final total = facturasSeleccionadas.fold(0, (previousValue, cartera) => previousValue + (cartera.valor ?? 0));
    final TextEditingController totalAbonoController = TextEditingController(
        text:formatter.format(total.toString())
    );

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
                              _buildListItem('Vence', facturasSeleccionadas[index].fecha_pago.toString()),
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
              TextField(
                controller: totalAbonoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total abono',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedEntity,
                onChanged: (newValue) {
                  setState(() {
                    selectedEntity = newValue;
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
              ),
              Container(
                margin: const EdgeInsets.only(top: 20), // Margen superior de 20
                width: 100,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1), // Borde del contenedor
                ),
                child: Center(
                  child: Image.asset(
                    'assets/splash.png', // Ruta de la imagen
                    width: double.infinity, // Ajusta la imagen al ancho del contenedor
                    height: double.infinity, // Ajusta la imagen al alto del contenedor
                    fit: BoxFit.contain, // Ajusta la imagen al tamaño del contenedor manteniendo la proporción
                  ),
                  /*Icon(
                    Icons.camera_alt,
                    size: 50, // Tamaño del icono
                    color: Colors.grey, // Color del icono
                  ),*/
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed:(){
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