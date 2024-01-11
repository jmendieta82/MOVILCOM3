import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../internet_services/reportes/reporte_pagos_api_connection.dart';
import '../models/reportes/reporte_pagos.dart';


final reportePagosListProvider = FutureProvider.family<List<ReportePagos>,Tuple4>((ref,tuple) async {
  return ref.watch(reportePagosProvider).getReportePagos(tuple.item1,tuple.item2,tuple.item3,tuple.item4);
});
