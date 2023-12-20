import 'package:movilcomercios/src/models/saldos/cartera.dart';
import '../dio/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarteraApiConection{

  Future<List<Cartera>> getCarteraList(String token,int nodoId) async {
    DioClient.instance.setAuthToken(token);
    final response = await DioClient.instance.get('cartera_appv3/?nodo=$nodoId');
    return (response).map((e) => Cartera.fromJson(e)).toList();
  }
}
final carteraProvider =  Provider<CarteraApiConection>((ref)  => CarteraApiConection());