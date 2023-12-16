import 'package:movilcomercios/src/models/saldos/credito.dart';
import '../dio/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CreditoApiConection{

  Future<Credito> getCredito(String token,int nodoId) async {
    DioClient.instance.setAuthToken(token);
    final response = await DioClient.instance.get('creditos/?nodo=$nodoId');
    return (response).map((e) => Credito.fromJson(e)).toList().first;
  }
}

final creditoActualProvider =  Provider<CreditoApiConection>((ref)  => CreditoApiConection());