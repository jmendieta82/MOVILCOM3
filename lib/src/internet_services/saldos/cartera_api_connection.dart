import 'package:movilcomercios/src/models/saldos/cartera.dart';
import '../dio/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarteraApiConection{

  Future<List<Cartera>> getCarteraList(String token,int nodoId) async {
    DioClient conexion = DioClient.instance;
    bool isConnected = await conexion.checkInternetConnection();
    if(isConnected){
      conexion.setUrl('cartera_appv3/?nodo=$nodoId',token:token);
    }else{
      conexion.setUrlConceptoMovilLogin('cartera_appv3/?nodo=$nodoId',token:token);
    }
    final response = await conexion.get('');
    return (response).map((e) => Cartera.fromJson(e)).toList();
  }
}
final carteraProvider =  Provider<CarteraApiConection>((ref)  => CarteraApiConection());