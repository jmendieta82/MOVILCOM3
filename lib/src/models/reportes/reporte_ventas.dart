class ReporteVentas {
  int? total_valor;
  int? total_ganancia;

  ReporteVentas({this.total_valor, this.total_ganancia});

  ReporteVentas.fromJson(Map<String, dynamic> json) {
    total_valor = json['total_valor'];
    total_ganancia = json['total_ganancia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_valor'] = total_valor;
    data['total_ganancia'] = total_ganancia;
    return data;
  }
}