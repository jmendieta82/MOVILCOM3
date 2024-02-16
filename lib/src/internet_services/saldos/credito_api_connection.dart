import 'package:movilcomercios/src/models/saldos/credito.dart';
import '../dio/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CreditoApiConection{

  Future<Credito> getCredito(String token,int nodoId) async {
    DioClient conexion = DioClient.instance;
    bool isConnected = await conexion.checkInternetConnection();
    if(isConnected){
      conexion.setUrl('creditos/?nodo=$nodoId',token:token);
    }else{
      conexion.setUrlOffLine('creditos/?nodo=$nodoId',token:token);
    }
    final response = await conexion.get('');
    return (response).map((e) => Credito.fromJson(e)).toList().first;
  }
}

final creditoActualProvider =  Provider<CreditoApiConection>((ref)  => CreditoApiConection());