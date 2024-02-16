
import 'package:movilcomercios/src/models/common/bolsa.dart';
import '../dio/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class BolsaApiConection{

  Future<Bolsa> getBolsa(String token,String nodoId) async {
    DioClient conexion = DioClient.instance;
    bool isConnected = await conexion.checkInternetConnection();
    if(isConnected){
      conexion.setUrl('bolsa_dinero_app/?nodo=$nodoId',token:token);
    }else{
      conexion.setUrlOffLine('bolsa_dinero_app/?nodo=$nodoId',token:token);
    }
    final response = await conexion.get('');
    return (response).map((e) => Bolsa.fromJson(e)).toList().first;
  }
}

final bolsaActualProvider =  Provider<BolsaApiConection>((ref)  => BolsaApiConection());