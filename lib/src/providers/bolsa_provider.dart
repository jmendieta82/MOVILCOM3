import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/common/bolsa.dart';
import '../internet_services/common/bolsa_api_connection.dart';

final bolsaProvider = FutureProvider.family<Bolsa,String>((ref,token) async {
  return ref.watch(bolsaActualProvider).getBolsa(token);
});
