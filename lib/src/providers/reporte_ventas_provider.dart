
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../internet_services/reportes/reporte_ventas_api_connection.dart';
import '../models/reportes/reporte_ventas.dart';

final reporteVentasDataProvider = FutureProvider.family<ReporteVentas,Tuple4>((ref,tuple) async {
  return ref.watch(reporteVentasProvider).getReporteVentas(tuple.item1,tuple.item2,tuple.item3,tuple.item4);
});

