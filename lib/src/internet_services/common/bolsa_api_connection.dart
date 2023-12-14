
import 'package:movilcomercios/src/models/common/bolsa.dart';
import '../dio/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class BolsaApiConection{

  Future<Bolsa> getBolsa(String token) async {
    DioClient.instance.setAuthToken(token);
    final response = await DioClient.instance.get('bolsa_dinero_app/?nodo=15');
    return (response).map((e) => Bolsa.fromJson(e)).toList().first;
  }
}

final bolsaActualProvider =  Provider<BolsaApiConection>((ref)  => BolsaApiConection());