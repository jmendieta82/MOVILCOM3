import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/saldos/saldo_response.dart';
import '../dio/dio_client.dart';

Future<SaldoResponse> solicitudSaldo(obj) async {
  final response = await DioClient.instance.post('solicitar_saldo', data: obj);
  return SaldoResponse.fromJson(response);
}


final metodoSeleccionadoProvider = StateProvider<String>((ref) => 'Contado');
final valorSolicitudProvider = StateProvider<String>((ref) => '');
final imagen64Provider = StateProvider<String>((ref) => '');
final imagenProvider = StateProvider<String>((ref) => '');
final respuestaSaldoPovider = StateProvider<List?>((ref) =>[]);