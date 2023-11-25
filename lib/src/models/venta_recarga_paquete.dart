class VentaRecargaPaquete {
  String? codigo;
  String? mensaje;

  VentaRecargaPaquete({this.codigo, this.mensaje});

  VentaRecargaPaquete.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    mensaje = json['mensaje'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codigo'] = codigo;
    data['mensaje'] = mensaje;
    return data;
  }
}