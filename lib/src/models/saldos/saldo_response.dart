

class SaldoResponse {
  String? codigo;
  List<dynamic>? mensaje; // Cambio a List<dynamic> en lugar de List?

  SaldoResponse({this.codigo, this.mensaje});

  SaldoResponse.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    if (json['mensaje'] != null) {
      mensaje = List<dynamic>.from(json['mensaje']); // Convertir a List<dynamic>
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData['codigo'] = codigo;
    jsonData['mensaje'] = mensaje;
    return jsonData;
  }
}