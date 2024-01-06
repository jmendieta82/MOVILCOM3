import '../../models/reportes/reporte_ventas.dart';
import '../dio/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReporteVentasApiConection{

  Future<ReporteVentas> getReporteVentas(String token,int nodoId,String fechaInicial,String fechaFinal)async {
    DioClient conexion = DioClient.instance;
    bool isConnected = await conexion.checkInternetConnection();
    final obj = {
      'fechaInicial': fechaInicial,
      'fechaFinal': fechaFinal,
      'nodo': nodoId,
    };
    if (isConnected) {
      conexion.setUrl('ventas_by_fecha_v3', token: token);
    } else {
      conexion.setUrlConceptoMovilLogin('ventas_by_fecha_v3', token: token);
    }
    final response = await conexion.post('', data: obj);
    return ReporteVentas.fromJson(response);
  }
}

final reporteVentasProvider =  Provider<ReporteVentasApiConection>((ref)  => ReporteVentasApiConection());
