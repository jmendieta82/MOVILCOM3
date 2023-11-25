class Categoria {
  int? id;
  String? nombre;
  String? imagen;
  String? createdAt;
  String? updatedAt;

  Categoria({this.id, this.nombre, this.imagen, this.createdAt, this.updatedAt});

  Categoria.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    imagen = json['imagen'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nombre'] = nombre;
    data['imagen'] = imagen;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}