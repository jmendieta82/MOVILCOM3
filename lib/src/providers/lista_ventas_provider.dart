
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/internet_services/lista_ventas_conection.dart';
import 'package:movilcomercios/src/models/lista_ventas.dart';

final listaVentaListProvider = FutureProvider<List<ListaVentas>>((ref) async {
  return ref.watch(listaVentasProvider).getListaVentasList();
});

final categoriaSeleccionadaProvider = StateProvider<String>((ref) => '');
final empresaSeleccionadaProvider = StateProvider<ListaVentas>((ref) => ListaVentas());