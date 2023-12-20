import 'package:movilcomercios/src/models/common/transaccion.dart';

class VentaResponse {
  dynamic codigo;
  String? mensaje;
  Transaccion? data;

  VentaResponse({this.codigo, this.mensaje,/*this.data*/});

  VentaResponse.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    mensaje = json['mensaje'];
    data = json['data']!= ''?Transaccion.fromJson(json['data']):data = null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData['codigo'] = codigo;
    jsonData['mensaje'] = mensaje;
    jsonData['data'] = data?.toJson();
    return jsonData;
  }
}