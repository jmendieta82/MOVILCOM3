
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/internet_services/dio/dio_exception.dart';
import 'package:movilcomercios/src/models/common/usuario_actual.dart';
import '../dio/dio_client.dart';


Future<bool> checkInternetConnection() async {
  try {
    Dio dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 5); // Timeout de conexión de 5 segundos
    dio.options.receiveTimeout = const Duration(seconds: 5); // Timeout de recepción de 5 segundos
    Response response = await dio.get('https://www.google.com');
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}

Future<UsuarioActual> loginUsuario(String username,String password) async {
  bool isConnected = await checkInternetConnection();
  DioClient conexion = DioClient.instance;
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

