import '../../models/reportes/reporte_pagos.dart';
import '../../models/reportes/reporte_ventas.dart';
import '../dio/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*class ReportePagosApiConection{

  Future<List<ReportePagos>> getReportePagos(String token,int nodoId,String fechaInicial,String fechaFinal)async {
    DioClient conexion = DioClient.instance;
    bool isConnected = await conexion.checkInternetConnection();
    String url = 'pagos_by_fecha_v3/?fecha=$fechaInicial&fecha2=$fechaFinal&nodo=$nodoId';
    if (isConnected) {
      conexion.setUrl(url, token: token);
    } else {
      conexion.setUrlConceptoMovilLogin(url, token: token);
    }
    final response = await conexion.get('');
    return (response).map((e) => ReportePagos.fromJson(e)).toList();
  }
}

final reportePagosProvider =  Provider<ReportePagosApiConection>((ref)  => ReportePagosApiConection());*/
Future<List<ReportePagos>> getReportePagos(String token,int nodoId,String fechaInicial,String fechaFinal)async {
  DioClient conexion = DioClient.instance;
  bool isConnected = await conexion.checkInternetConnection();
  String url = 'pagos_by_fecha_v3/?fecha=$fechaInicial&fecha2=$fechaFinal&nodo=$nodoId';
  if (isConnected) {
    conexion.setUrl(url, token: token);
  } else {
    conexion.setUrlConceptoMovilLogin(url, token: token);
  }
  final response = await conexion.get('');
  return (response).map((e) => ReportePagos.fromJson(e)).toList();
}
