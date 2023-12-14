class Convenio {
  String? id;
  String? nombre;
  String? tipo;

  Convenio({this.id, this.nombre, this.tipo});

  Convenio.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    tipo = json['tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nombre'] = nombre;
    data['tipo'] = tipo;
    return data;
  }
}