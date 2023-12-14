import 'package:movilcomercios/src/models/common/transaccion.dart';

class VentaResponse {
  String? codigo;
  String? mensaje;
  Transaccion? data;

  VentaResponse({this.codigo, this.mensaje,/*this.data*/});

  VentaResponse.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    mensaje = json['mensaje'];
    data = Transaccion.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData['codigo'] = codigo;
    jsonData['mensaje'] = mensaje;
    jsonData['data'] = data?.toJson();
    return jsonData;
  }
}