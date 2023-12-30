
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/internet_services/dio/dio_exception.dart';
import 'package:movilcomercios/src/models/common/usuario_actual.dart';
import '../dio/dio_client.dart';


Future<UsuarioActual> loginUsuario(String username,String password) async {
  DioClient conexion = DioClient.instance;
  bool isConnected = await conexion.checkInternetConnection();
  if(isConnected){
    conexion.setUrl('api-token-auth3');
  }else{
    conexion.setUrlConceptoMovilLogin('api-token-auth3');
  }
  try{
    final response = await conexion.post('', data: {"username":username, "password":password});
    return UsuarioActual.fromJson(response);
  }on DioExceptionCustom catch(error){
    throw error.errorMessage;
  }

}

final usuarioConectadoProvider = StateProvider<UsuarioActual>((ref) => UsuarioActual());
final progressProvider = StateProvider<bool>((ref) => false);

