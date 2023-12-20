import 'package:dio/dio.dart';

class DioExceptionCustom implements Exception{
  late String errorMessage;

  DioExceptionCustom.fromDioError(DioError dioError){
    switch(dioError.type){
      case DioExceptionType.cancel:
        errorMessage = "La consulta al servidor ha sido cancelada";
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = "Intento de conexion fallida.";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Tiempo de espera agotado, intenta mas tarde.";
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "Tiempo de espera agotado, intenta mas tarde.";
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleStatusCode(dioError.response?.statusCode);
        break;
      case DioExceptionType.unknown:
        if (dioError.message!.contains('SocketException')) {
          errorMessage = 'Sin conexion';
          break;
        }
        errorMessage = 'Ha ocurrido un error inesperado';
        break;
      default:
        errorMessage = 'Algo ha ido mal.';
        break;
    }
  }
  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'El usuario ya existe';
      case 401:
        return 'Fallo de autenticacion';
      case 403:
        return 'Este usuario no tiene permiso para este recurso.';
      case 404:
        return 'El recurso solicitado no existe';
      case 500:
        return 'Error interno del servidor';
      default:
        return 'Oops algo ha ido mal.!';
    }
  }

  @override
  String toString()=> errorMessage;
}