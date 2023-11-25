
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/ultimas_ventas.dart';
import '../internet_services/ultimas_ventas_api_conection.dart';

final ultimasVentasListProvider = FutureProvider<List<UltimasVentas>>((ref) async {
  return ref.watch(ultimasVentsaProvider).getUltimasVentasList();
});