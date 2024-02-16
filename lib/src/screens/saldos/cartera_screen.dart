import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/saldos/cartera.dart';
import 'package:movilcomercios/src/providers/cartera_provider.dart';
import 'package:tuple/tuple.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../providers/credito_provider.dart';
import '../../providers/shared_providers.dart';


class CarteraScreen extends ConsumerStatefulWidget {
  const CarteraScreen({super.key});

  @override
  ConsumerState createState() => _CarteraScreenState();
}

class _CarteraScreenState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    Tuple2 params = Tuple2(usuarioConectado.token, usuarioConectado.nodoId);
    final data  = ref.watch(carteraListProvider(params));
    final router  = ref.watch(appRouteProvider);
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'es-Co', decimalDigits: 0,symbol: '',
    );
    final facturasSeleccionadas = ref.watch(facturasSeleccionadasProvider);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Cartera'),
          leading: IconButton(
              onPressed: (){
                router.go('/saldos');
              },
              icon: const Icon(Icons.arrow_back_ios)),
        actions: [
          IconButton(
              onPressed: (){
                ref.invalidate(carteraListProvider);
                ref.invalidate(creditoProvider);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Informacion actualizada.')),
                );
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: SizedBox(
        child: data.when(
            data: (data){
              List<Cartera> list  = data.map((e) => e).toList();
              final total = facturasSeleccionadas.fold(0, (previousValue, cartera) => previousValue + (cartera.valor ?? 0));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: SizedBox(
                      height: 60.0, // Cambia la altura aquí según tus necesidades
                      child: GestureDetector(
                        onTap: (){
                          if(facturasSeleccionadas.isNotEmpty){
                            router.go('/pago_facturas');
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No hay facturas seleccionadas.')),
                            );
                          }
                        },
                        child: Card(
                          color: Colors.amber,
                          child: Center(
                            child: facturasSeleccionadas.isNotEmpty?Text(
                                'Pagar ${facturasSeleccionadas.length.toString()} facturas por \$${formatter.format(total.toString())}.',
                                style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.white),
                              ):
                              const Text(
                                  'Seleccione las facturas que quiera pagar.',
                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        shrinkWrap: true,
                        itemBuilder: (_,index){
                          final valor = int.parse(list[index].valor.toString());
                          final saldoPendientePago = int.parse(list[index].saldo_pendiente_pago.toString());
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  if(list[index].estadoPago != 'Pago en revision'){
                                    final itemIndex = facturasSeleccionadas.indexOf(list[index]);
                                    if (itemIndex != -1) {
                                      // Si el elemento ya está en la lista, quítalo
                                      ref.read(facturasSeleccionadasProvider.notifier).update(
                                            (state) => List<Cartera>.from(state)..remove(list[index]),
                                      );
                                    } else {
                                      // Si el elemento no está en la lista, agrégalo
                                      ref.read(facturasSeleccionadasProvider.notifier).update(
                                            (state) => [...state, list[index]],
                                      );
                                    }
                                    // Cambiar el estado de 'seleccionado' para la visualización
                                    list[index].seleccionado = !list[index].seleccionado;
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Esta factura aun esta en revision.')),
                                    );
                                  }
                                });
                              },
                              child: Card(
                                color: (list[index].seleccionado) ? Colors.green[100] : null,
                                child: ListTile(
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildListItem('Transaccion',list[index].id.toString()),
                                      _buildListItem('Pagado',formatter.format((valor - saldoPendientePago).toString())),
                                      _buildListItem('Saldo',formatter.format(saldoPendientePago.toString())),
                                      _buildListItem('Fecha',list[index].fecha_aprobacion.toString()),
                                      _buildListItem('Estado pago',list[index].estadoPago.toString()),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ],
              );
            },
            error: (err,s) => Text(err.toString()),
            loading: () => const Center(child: CircularProgressIndicator(),)),
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