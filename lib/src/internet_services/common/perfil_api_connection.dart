import 'dart:async';
import 'package:movilcomercios/src/internet_services/dio/dio_exception.dart';
import 'package:movilcomercios/src/models/common/usuario_actual.dart';
import '../dio/dio_client.dart';


Future<UsuarioActual> updateUsuario(UsuarioActual usuario) async {
  DioClient conexion = DioClient.instance;
  final url = 'updatepwd/${usuario.id}/';
  bool isConnected = await conexion.checkInternetConnection();
  if(isConnected){
    conexion.setUrl(url);
  }else{
    conexion.setUrlOffLine(url);
  }
  try{
    final response = await conexion.update('', data: usuario);
    return UsuarioActual.fromJson(response);
  }on DioExceptionCustom catch(error){
    throw error.errorMessage;
  }

}
