import '../../models/reportes/reporte_pagos.dart';
import '../dio/dio_client.dart';

Future<List<ReportePagos>> getReportePagos(String token,int nodoId,String fechaInicial,String fechaFinal)async {
  DioClient conexion = DioClient.instance;
  bool isConnected = await conexion.checkInternetConnection();
  String url = 'pagos_by_fecha_v3/?fecha=$fechaInicial&fecha2=$fechaFinal&nodo=$nodoId';
  if (isConnected) {
    conexion.setUrl(url, token: token);
  } else {
    conexion.setUrlOffLine(url, token: token);
  }
  final response = await conexion.get('');
  return (response).map((e) => ReportePagos.fromJson(e)).toList();
}
