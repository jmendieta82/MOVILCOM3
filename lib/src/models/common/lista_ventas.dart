
class ListaVentas {
  int? id;
  String? nom_categoria;
  int? id_categoria;
  String? nom_empresa;
  String? logo_empresa;
  int? empresa_id;
  int? proveedor_id;
  int? nodo_id;
  double? micomision;

  ListaVentas({
    this.id,
    this.nom_categoria,
    this.id_categoria,
    this.nom_empresa,
    this.logo_empresa,
    this.empresa_id,
    this.proveedor_id,
    this.nodo_id,
    this.micomision,
  });

  ListaVentas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom_categoria = json['nom_categoria'];
    id_categoria = json['id_categoria'];
    nom_empresa = json['nom_empresa'];
    logo_empresa = json['logo_empresa_assets'] != null && json['logo_empresa_assets'] != '' ? json['logo_empresa_assets'] : 'assets/img-empresas/no_image.png';
    empresa_id = json['empresa_id'];
    proveedor_id = json['proveedor_id'];
    nodo_id = json['nodo_id'];
    micomision = json['micomision'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom_categoria'] = nom_categoria;
    data['id_categoria'] = id_categoria;
    data['nom_empresa'] = nom_empresa;
    data['logo_empresa'] = logo_empresa;
    data['empresa_id'] = empresa_id;
    data['proveedor_id'] = proveedor_id;
    data['nodo_id'] = nodo_id;
    data['micomision'] = micomision;
    return data;
  }
}