import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/saldos/cartera.dart';
import 'package:tuple/tuple.dart';
import '../internet_services/saldos/cartera_api_connection.dart';

final carteraListProvider = FutureProvider.family<List<Cartera>,Tuple2>((ref,tuple) async {
  return ref.watch(carteraProvider).getCarteraList(tuple.item1,tuple.item2);
});

