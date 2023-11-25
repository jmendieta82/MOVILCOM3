class Paquetes {
  int? id;
  String? catServicio;
  String? nomEmpresa;
  bool? activo;
  String? imagen;
  int? posicionMenu;
  String? createdAt;
  String? updatedAt;

  Paquetes({this.id, this.catServicio, this.nomEmpresa, this.activo, this.imagen, this.posicionMenu,this.createdAt,this.updatedAt});

  Paquetes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catServicio = json['catServicio_id'];
    nomEmpresa = json['nom_empresa'];
    activo = json['activo'];
    imagen = json['imagen'] != null && json['imagen'] != '' ? json['imagen'] : 'assets/img-empresas/no_image.png';
    posicionMenu = json['posicion_menu'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['catServicio'] = catServicio;
    data['nom_empresa'] = nomEmpresa;
    data['activo'] = activo;
    data['imagen'] = imagen;
    data['posicion_menu'] = posicionMenu;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}