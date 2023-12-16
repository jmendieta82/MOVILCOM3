import 'package:movilcomercios/src/models/saldos/ultimas_solicitudes.dart';
import '../dio/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UltimasSolicitudesApiConection{

  Future<List<UltimasSolicitudes>> getUltimasSolicitudesList(String token,int nodoId) async {
    DioClient.instance.setAuthToken(token);
    final response = await DioClient.instance.get('mis_solicitudes_saldo_movilV3/?nodo=$nodoId');
    return (response).map((e) => UltimasSolicitudes.fromJson(e)).toList();

  }
}

final ultimasSolicitudesProvider =  Provider<UltimasSolicitudesApiConection>((ref)  => UltimasSolicitudesApiConection());