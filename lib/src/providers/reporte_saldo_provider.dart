import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../internet_services/reportes/reporte_solicitudes_saldo_api_connection.dart';
import '../models/saldos/ultimas_solicitudes.dart';

final reporteSaldoListProvider = FutureProvider.family<List<UltimasSolicitudes>,Tuple4>((ref,tuple) async {
  return ref.watch(reporteSolicitudesProvider).getReporteSolicitudesList(tuple.item1,tuple.item2,tuple.item3,tuple.item4);
});
