import '../../models/common/ultimas_ventas.dart';
import '../dio/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetalleReporteVentasApiConection{

  Future<List<UltimasVentas>> getReporteVentasList(String token,int nodoId,fInicial,fFinal) async {
    DioClient conexion = DioClient.instance;
    bool isConnected = await conexion.checkInternetConnection();
    if(isConnected){
      conexion.setUrl('ventas_by_fecha_detail_v3/?nodo=$nodoId&fechaInicial=$fInicial&fechaFinal=$fFinal',token:token);
    }else{
      conexion.setUrlConceptoMovilLogin('ventas_by_fecha_detail_v3/?nodo=$nodoId&fechaInicial=$fInicial&fechaFinal=$fFinal',token:token);
    }
    final response = await conexion.get('');
    return (response).map((e) => UltimasVentas.fromJson(e)).toList();
  }
}

final detalleReporteVentasProvider =  Provider<DetalleReporteVentasApiConection>((ref)  => DetalleReporteVentasApiConection());