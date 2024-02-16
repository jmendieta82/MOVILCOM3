import 'package:movilcomercios/src/models/recargas/ws_recargas.dart';
import '../../models/common/venta_response.dart';
import '../dio/dio_client.dart';

Future<VentaResponse> ventaRecarga(MSData obj) async {
  DioClient conexion = DioClient.instance;
  bool isConnected = await conexion.checkInternetConnection();
  if(isConnected){
    conexion.setUrl('recargas_ver2_ms');
  }else{
    conexion.setUrlOffLine('recargas_ver2_ms');
  }
  final response = await DioClient.instance.post('', data: obj.toJson());
  return VentaResponse.fromJson(response);
}

Future<VentaResponse> ventaRecaudo(obj) async {
  DioClient conexion = DioClient.instance;
  bool isConnected = await conexion.checkInternetConnection();
  if(isConnected){
    conexion.setUrl('pago_factura_practi');
  }else{
    conexion.setUrlOffLine('pago_factura_practi');
  }
  try{
    final response = await conexion.post('', data: obj);
    return VentaResponse.fromJson(response);
  }catch(error){
    throw Exception('Error en la solicitud: $error');
  }
}