
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/internet_services/common/lista_ventas_conection.dart';
import 'package:movilcomercios/src/models/common/lista_ventas.dart';
import 'package:tuple/tuple.dart';

final listaVentaListProvider = FutureProvider.family<List<ListaVentas>,Tuple2>((ref,tuple) async {
  //item1 = token, item2 = nodo_id
  return ref.watch(listaVentasProvider).getListaVentasList(tuple.item1,tuple.item2);
});

final categoriaSeleccionadaProvider = StateProvider<String>((ref) => '');
final empresaSeleccionadaProvider = StateProvider<ListaVentas>((ref) => ListaVentas());