import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/saldos/saldo_response.dart';
import '../dio/dio_client.dart';

Future<SaldoResponse> solicitudSaldo(obj) async {
  DioClient conexion = DioClient.instance;
  bool isConnected = await conexion.checkInternetConnection();
  if(isConnected){
    conexion.setUrl('solicitar_saldo');
  }else{
    conexion.setUrlConceptoMovilLogin('solicitar_saldo');
  }
  final response = await conexion.post('', data: obj);
  return SaldoResponse.fromJson(response);
}


final metodoSeleccionadoProvider = StateProvider<String>((ref) => 'Crédito');
final valorSolicitudProvider = StateProvider<String>((ref) => '');
final imagen64Provider = StateProvider<String>((ref) => '');
final imagenProvider = StateProvider<String>((ref) => '');
final respuestaSaldoPovider = StateProvider<List?>((ref) =>[]);