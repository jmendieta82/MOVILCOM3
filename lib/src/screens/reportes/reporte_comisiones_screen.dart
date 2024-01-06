import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movilcomercios/src/providers/shared_providers.dart';
import 'package:tuple/tuple.dart';

import '../../app_router/app_router.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../models/common/lista_ventas.dart';
import '../../providers/lista_ventas_provider.dart';

class ReporteComisionesScreen extends ConsumerStatefulWidget {
  const ReporteComisionesScreen({super.key});

  @override
  ConsumerState<ReporteComisionesScreen> createState() => _ReporteComisionesScreenState();
}

class _ReporteComisionesScreenState extends ConsumerState<ReporteComisionesScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> entities = ['Recargas y Paquetes','Pines', 'Apuestas', 'Recaudos'];
    String? selectedEntity;
    final categoriaSeleccionadaReporte = ref.watch(categoriaSeleccionadaProvider);
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    var params = Tuple2(usuarioConectado.token, usuarioConectado.nodoId);
    final data  = ref.watch(listaVentaListProvider(params));
    final router = ref.watch(appRouteProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de comisiones'),
        leading:IconButton(
            onPressed: (){
              router.go('/reportes');
              ref.read(categoriaSeleccionadaProvider.notifier).update((state) => '');
            },
            icon: const Icon(Icons.arrow_back_ios)
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
              child:data.when(
                  data: (data){
                    List<ListaVentas> list = data.where((element) => element.nom_categoria == categoriaSeleccionadaReporte).toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedEntity,
                            onChanged: (newValue) {
                              setState(() {
                                selectedEntity = newValue;
                              });
                              ref.read(categoriaSeleccionadaProvider.notifier).update((state) => newValue!);
                            },
                            items: entities.map((entity) {
                              return DropdownMenuItem<String>(
                                value: entity,
                                child: Text(entity),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: 'Categorias',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: list.length,
                              shrinkWrap: true,
                              itemBuilder: (_,index){
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: _buildListItem(
                                        list[index].nom_empresa.toString(),
                                        list[index].micomision.toString()
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
          )
        ],
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