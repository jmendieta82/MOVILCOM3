import 'package:movilcomercios/src/models/recargas/ws_recargas.dart';
import '../../models/common/venta_response.dart';
import '../dio/dio_client.dart';

Future<VentaResponse> ventaRecarga(MSData obj) async {
  final response = await DioClient.instance.post('recargas_ver2_ms', data: obj.toJson());
  return VentaResponse.fromJson(response);
}

Future<VentaResponse> ventaRecaudo(obj) async {
  try{
    final response = await DioClient.instance.post('pago_factura_practi', data: obj);
    print(response);
    return VentaResponse.fromJson(response);
  }catch(error){
    throw Exception('Error en la solicitud: $error');
  }
}