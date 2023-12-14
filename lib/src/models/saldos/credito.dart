class Credito {
  int? id;
  int? montoAutorizado;
  int? plazoMaximo;
  int? montoUtilizado;
  int? montoDisponible;

  Credito(
      {
        this.id,
        this.montoAutorizado,
        this.plazoMaximo,
        this.montoUtilizado,
        this.montoDisponible,
      }
      );

  Credito.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    montoAutorizado = json['montoAutorizado'];
    plazoMaximo = json['plazoMaximo'];
    montoUtilizado = json['montoUtilizado'];
    montoDisponible = json['montoDisponible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['montoAutorizado'] = montoAutorizado;
    data['plazoMaximo'] = plazoMaximo;
    data['montoUtilizado'] = montoUtilizado;
    data['montoDisponible'] = montoDisponible;
    return data;
  }
}