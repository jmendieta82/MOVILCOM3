
import '../dio/dio_client.dart';
import '../../models/common/ultimas_ventas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UltimasVentasApiConection{

  Future<List<UltimasVentas>> getUltimasVentasList(String token,int nodoId) async {
    DioClient.instance.setAuthToken(token);
    final response = await DioClient.instance.get('ultimas_ventas_app/?nodo=$nodoId');
    return (response).map((e) => UltimasVentas.fromJson(e)).toList();

  }
}

final ultimasVentsaProvider =  Provider<UltimasVentasApiConection>((ref)  => UltimasVentasApiConection());