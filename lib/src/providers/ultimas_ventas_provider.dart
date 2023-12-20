
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/common/ultimas_ventas.dart';
import 'package:tuple/tuple.dart';
import '../internet_services/common/ultimas_ventas_api_conection.dart';

final ultimasVentasListProvider = FutureProvider.family<List<UltimasVentas>,Tuple2>((ref,tuple) async {
  return ref.watch(ultimasVentsaProvider).getUltimasVentasList(tuple.item1,tuple.item2);
});

