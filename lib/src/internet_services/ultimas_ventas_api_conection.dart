import 'dio/paths.dart';
import 'dio/dio_client.dart';
import '../models/ultimas_ventas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UltimasVentasApiConection{

  Future<List<UltimasVentas>> getUltimasVentasList() async {
    final response = await DioClient.instance.get(ultimas_ventas);
    return (response).map((e) => UltimasVentas.fromJson(e)).toList();

  }
}

final ultimasVentsaProvider =  Provider<UltimasVentasApiConection>((ref)  => UltimasVentasApiConection());