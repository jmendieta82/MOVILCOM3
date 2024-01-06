
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/common/ultimas_ventas.dart';
import 'package:tuple/tuple.dart';
import '../internet_services/reportes/detalle_reporte_ventas.dart';

final detalleReporteVentasListProvider = FutureProvider.family<List<UltimasVentas>,Tuple4>((ref,tuple) async {
  return ref.watch(detalleReporteVentasProvider).getReporteVentasList(tuple.item1,tuple.item2,tuple.item3,tuple.item4);
});

