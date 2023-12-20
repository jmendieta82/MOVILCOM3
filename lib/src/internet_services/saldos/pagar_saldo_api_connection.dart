import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/common/venta_response.dart';
import 'package:movilcomercios/src/models/saldos/saldo_response.dart';
import '../dio/dio_client.dart';

Future<VentaResponse> pagarSaldo(obj) async {
  final response = await DioClient.instance.post('pagar_facturas_revision', data: obj);
  return VentaResponse.fromJson(response);
}
