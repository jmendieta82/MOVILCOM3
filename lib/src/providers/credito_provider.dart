import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../internet_services/saldos/credito_api_connection.dart';
import '../models/saldos/credito.dart';

final creditoProvider = FutureProvider.family<Credito,Tuple2>((ref,tuple) async {
  return ref.watch(creditoActualProvider).getCredito(tuple.item1,tuple.item2);
});
