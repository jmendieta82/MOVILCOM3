import 'package:movilcomercios/src/models/saldos/ultimas_solicitudes.dart';
import '../dio/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UltimasSolicitudesApiConection{

  Future<List<UltimasSolicitudes>> getUltimasSolicitudesList(String token,int nodoId) async {
    DioClient conexion = DioClient.instance;
    bool isConnected = await conexion.checkInternetConnection();
    if(isConnected){
      conexion.setUrl('mis_solicitudes_saldo_movilV3/?nodo=$nodoId',token:token);
    }else{
      conexion.setUrlConceptoMovilLogin('mis_solicitudes_saldo_movilV3/?nodo=$nodoId',token:token);
    }
    final response = await conexion.get('');
    print(response);
    return (response).map((e) => UltimasSolicitudes.fromJson(e)).toList();
  }
}

final ultimasSolicitudesProvider =  Provider<UltimasSolicitudesApiConection>((ref)  => UltimasSolicitudesApiConection());