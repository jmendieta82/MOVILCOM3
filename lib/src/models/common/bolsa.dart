class Bolsa {
  int? id;
  int? saldo_disponible;
  int? utilidad;

  Bolsa({this.id, this.saldo_disponible, this.utilidad});

  Bolsa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    saldo_disponible = json['saldo_disponible'];
    utilidad = json['utilidad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['saldo_disponible'] = saldo_disponible;
    data['utilidad'] = utilidad;
    return data;
  }
}