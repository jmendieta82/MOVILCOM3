
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/paquetes.dart';
import '../internet_services/paquetes_api_connection.dart';

final paquetesListProvider = FutureProvider<List<Paquetes>>((ref) async {
  return ref.watch(paquetesProvider).getPaquetesList();
});