import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/saldos/ultimas_solicitudes.dart';
import 'package:tuple/tuple.dart';
import '../internet_services/saldos/ultimas_solicitudes_api_connection.dart';

final ultimasSolicitudesListProvider = FutureProvider.family<List<UltimasSolicitudes>,Tuple2>((ref,tuple) async {
  return ref.watch(ultimasSolicitudesProvider).getUltimasSolicitudesList(tuple.item1,tuple.item2);
});

