import 'package:movilcomercios/src/internet_services/dio/paths.dart';
import '../models/venta_recarga_paquete.dart';
import 'dio/dio_client.dart';

class VentaApiConnection {
  Object? obj;

  VentaApiConnection({this.obj});

  Future<VentaRecargaPaquete> ventaRecarga() async {
    final response = await DioClient.instance.post(venta_recargas, data: obj);
    return VentaRecargaPaquete.fromJson(response);
  }
}
