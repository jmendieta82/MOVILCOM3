import 'package:movilcomercios/src/models/saldos/ultimas_solicitudes.dart';
import '../dio/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReporteSolicitudesApiConection{

  Future<List<UltimasSolicitudes>> getReporteSolicitudesList(String token,int nodoId,String fInicial,String fFinal) async {
    DioClient conexion = DioClient.instance;
    bool isConnected = await conexion.checkInternetConnection();
    String url = 'solicitudes_by_fechaV3/?nodo=$nodoId&fechai=$fInicial&fechaf=$fFinal';
    if(isConnected){
      conexion.setUrl(url,token:token);
    }else{
      conexion.setUrlConceptoMovilLogin(url,token:token);
    }
    final response = await conexion.get('');
    return (response).map((e) => UltimasSolicitudes.fromJson(e)).toList();
  }
}

final reporteSolicitudesProvider =  Provider<ReporteSolicitudesApiConection>((ref)  => ReporteSolicitudesApiConection());