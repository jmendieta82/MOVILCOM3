import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_router/app_router.dart';
import '../../internet_services/recaudos/consulta_convenios_conection.dart';

class ConveniosScreen extends ConsumerStatefulWidget {
  const ConveniosScreen({super.key});

  @override
  ConsumerState createState() => _ConveniosScreenState();
}
class _ConveniosScreenState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    TextEditingController convenio = TextEditingController();
    final listaConvenios = ref.watch(conveniosListProvider);
    final route  = ref.watch(appRouteProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convenios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              route.go('/recaudos'); // Cierra el modal al presionar el botón
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Nombre de convenio', // Texto descriptivo o etiqueta
              ),
              controller: convenio,
              keyboardType: TextInputType.text,
              onChanged:(text){
                if(text.length >4){
                  getConveniosList(text).then((value){
                    ref.read(conveniosListProvider.notifier).update((state) => value);
                    print(value);
                  });
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listaConvenios.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: ListTile(
                    dense: true, // Reduce el espacio interno del ListTile
                    title: Text(listaConvenios[index].nombre.toString()),
                    onTap: () {
                        ref.read(convenioSeleccionadoProvider.notifier).update((state) => listaConvenios[index]);
                        route.go('/recaudos');
                    },
                  ),
                );
              },
            )
          ),
        ],
      ),
    );
  }
}