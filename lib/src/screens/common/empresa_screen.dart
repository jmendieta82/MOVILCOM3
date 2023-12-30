
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/app_router/app_router.dart';
import 'package:tuple/tuple.dart';
import '../../internet_services/common/login_api_conection.dart';
import '../../models/common/lista_ventas.dart';
import '../../models/recargas/paquetes.dart';
import '../../providers/lista_ventas_provider.dart';
import '../../providers/shared_providers.dart';

class EmpresaScreen extends ConsumerWidget {
  const EmpresaScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final usuarioConectado = ref.watch(usuarioConectadoProvider);
    var params = Tuple2(usuarioConectado.token, usuarioConectado.nodoId);
    final data  = ref.watch(listaVentaListProvider(params));
    final router = ref.watch(appRouteProvider);
    final categoriaSeleccionada = ref.watch(categoriaSeleccionadaProvider);



    return Scaffold(
      appBar: AppBar(
      leading:IconButton(
          onPressed: (){
            router.go('/home');
          },
          icon: const Icon(Icons.arrow_back_ios)
        ),
      title: Text(categoriaSeleccionada),
    ),
      body: data.when(
          data: (data){
            List<ListaVentas> list = data.where((element) => element.nom_categoria == categoriaSeleccionada).toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 1.0,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final empresa = list[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        ref.read(empresaSeleccionadaProvider.notifier).update((state) => state = empresa);
                        switch (empresa.nom_categoria){
                          case 'Recargas y Paquetes':
                            router.go('/recargas_paquetes');
                            ref.read(paqueteSeleccionadoProvider.notifier).update((state) =>Paquetes());
                            ref.read(fwdUrlImgProvider.notifier).update((state) =>'');
                            ref.read(selectedTabProvider.notifier).update((state) =>0);
                            break;
                          case 'Pines':
                            router.go('/pines');
                            ref.read(paqueteSeleccionadoProvider.notifier).update((state) =>Paquetes());
                            ref.read(fwdUrlImgProvider.notifier).update((state) =>'');
                            break;
                          case 'Apuestas':
                            router.go('/apuestas');
                            break;
                          case 'Recaudos':
                            router.go('/info_recaudo');
                            break;
                        }
                      },
                      child: CircleAvatar(
                        backgroundImage:AssetImage(empresa.logo_empresa ?? ''),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          error: (err,s) => Text(err.toString()),
          loading: () => const Center(child: CircularProgressIndicator()))
    );
  }
}
