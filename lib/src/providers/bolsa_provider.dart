import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/common/bolsa.dart';
import 'package:tuple/tuple.dart';
import '../internet_services/common/bolsa_api_connection.dart';

final bolsaProvider = FutureProvider.family<Bolsa,Tuple2>((ref,tuple) async {
  return ref.watch(bolsaActualProvider).getBolsa(tuple.item1,tuple.item2);
});
