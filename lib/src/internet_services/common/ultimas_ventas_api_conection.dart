
import '../dio/dio_client.dart';
import '../../models/common/ultimas_ventas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UltimasVentasApiConection{

  Future<List<UltimasVentas>> getUltimasVentasList(String token,int nodoId) async {
    DioClient conexion = DioClient.instance;
    bool isConnected = await conexion.checkInternetConnection();
    if(isConnected){
      conexion.setUrl('ultimas_ventas_app/?nodo=$nodoId',token:token);
    }else{
      conexion.setUrlOffLine('ultimas_ventas_app/?nodo=$nodoId',token:token);
    }
    final response = await conexion.get('');
    return (response).map((e) => UltimasVentas.fromJson(e)).toList();

  }
}

final ultimasVentsaProvider =  Provider<UltimasVentasApiConection>((ref)  => UltimasVentasApiConection());