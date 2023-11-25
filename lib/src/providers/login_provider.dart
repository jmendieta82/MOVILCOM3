
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/usuario_actual.dart';
import '../internet_services/login_api_conection.dart';


final loginAccesProvider = FutureProvider<UsuarioActual>((ref) async {
  return ref.watch(loginProvider).loginAccess();
});