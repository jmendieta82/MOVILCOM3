import 'package:movilcomercios/src/models/common/venta_response.dart';
import '../dio/dio_client.dart';

Future<VentaResponse> pagarSaldo(obj) async {
  DioClient conexion = DioClient.instance;
  bool isConnected = await conexion.checkInternetConnection();
  if(isConnected){
    conexion.setUrl('pagar_facturas_revision');
  }else{
    conexion.setUrlConceptoMovilLogin('pagar_facturas_revision');
  }
  final response = await conexion.post('', data: obj);
  return VentaResponse.fromJson(response);
}
