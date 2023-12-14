
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/internet_services/dio/dio_exception.dart';
import 'package:movilcomercios/src/models/common/usuario_actual.dart';
import '../dio/dio_client.dart';

Future<UsuarioActual> loginUsuario(String username,String password) async {
  try{
    final response = await DioClient.instance.post('api-token-auth3', data: {"username":username, "password":password});
    return UsuarioActual.fromJson(response);
  }on DioExceptionCustom catch(error){
    throw error.errorMessage;
  }

}

final usuarioConectadoProvider = StateProvider<UsuarioActual>((ref) => UsuarioActual());
final progressProvider = StateProvider<bool>((ref) => false);

