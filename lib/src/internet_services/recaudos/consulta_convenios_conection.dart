import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movilcomercios/src/models/recaudos/factura.dart';
import '../../models/recaudos/convenios.dart';
import '../dio/dio_client.dart';

Future<List<Convenio>> getConveniosList(parametro) async {
  final data = {
    'idcomercio': '113935',
    'claveventa': '1379',
    'tipoConsulta': 'convenios_consulta',
    'data': {'tipo': '0','key': parametro},
    'idTrx':'1',
    'end_point': 'preConsulta'
  };
  final response = await DioClient.instance.post('consulta_convenios_practi',data:data);
  final Map<String, dynamic> convenios = jsonDecode(response['data']['convenios']);
  List<Convenio> listaConvenios = [];
  for (var element in convenios.values) {
    listaConvenios.add(Convenio.fromJson(Map<String, dynamic>.from(element)));
  }

  return listaConvenios;

}

Future<FacturaReacudo> consultaReferencia(String convenio,String referencia) async {
  final data = {
    "idcomercio": '113935',
    "claveventa": '1379',
    "tipoConsulta":"consultaValorConvRef",
    "data":{
      "idConv":convenio,
      "extConvenio":referencia
    },
    "idTrx":"1",
    "end_point":"preConsulta"
  };
  final response = await DioClient.instance.post('consulta_convenios_practi',data:data);
  final Map<String, dynamic> factura = response['data'];
  return FacturaReacudo.fromJson(factura);

}

final conveniosListProvider = StateProvider<List<Convenio>>((ref) => []);
final convenioSeleccionadoProvider = StateProvider<Convenio>((ref) => Convenio());
final facturaSeleccionadaProvider = StateProvider<FacturaReacudo>((ref) => FacturaReacudo());