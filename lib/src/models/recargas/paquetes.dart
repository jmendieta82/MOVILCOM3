class Paquetes {
  int? id;
  int? codigoProducto;
  bool? activo;
  String? nomProducto;
  int? valorProducto;
  int? idProducto;
  int? idProveedor;
  String? nombreProv;

  Paquetes({
    this.id,
    this.codigoProducto,
    this.activo,
    this.nomProducto,
    this.valorProducto,
    this.idProducto,
    this.idProveedor,
    this.nombreProv,
  });

  Paquetes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codigoProducto = json['codigo_producto'];
    activo = json['activo'];
    nomProducto = json['nom_producto'];
    valorProducto = json['valor_producto'];
    idProducto = json['id_producto'];
    idProveedor = json['id_proveedor'];
    nombreProv = json['nombre_prov'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['codigo_producto'] = codigoProducto;
    data['activo'] = activo;
    data['nom_producto'] = nomProducto;
    data['valor_producto'] = valorProducto;
    data['id_producto'] = idProducto;
    data['id_proveedor'] = idProveedor;
    data['nombre_prov'] = nombreProv;
    return data;
  }
}