
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/internet_services/dio/paths.dart';
import 'package:movilcomercios/src/models/usuario_actual.dart';
import 'dio/dio_client.dart';
import '../models/login.dart';



class LoginApiConection{

  Future<UsuarioActual> loginAccess() async {
    final access = Login(username: 'carmencastro',password: '900123456');
    final response = await DioClient.instance.post(login,data: access);
    return UsuarioActual.fromJson(response);

  }
}

final loginProvider =  Provider<LoginApiConection>((ref)  => LoginApiConection());