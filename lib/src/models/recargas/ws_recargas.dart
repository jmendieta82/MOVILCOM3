class MSData {

  String? nodo;
  String? usuario_mrn;
  String? producto_venta;
  String? producto;
  int? valor;
  String? celular;
  String? canal_transaccion;
  String? transaccion_externa;
  String? documento;
  String? oficina;
  String? matricul;
  String? emai;
  String? recargas_multiproducto;
  String? token;
  String? nombr;
  String? cod_municipio;
  String? cant_sorteos;
  String? cant_cartones;
  String? bolsa_ganancia;
  bool? venta_ganancias;
  String? medioVenta ;
  String? tipo_datos ;
  String? tipo_red ;
  String? app_ver ;

  MSData({
    this.nodo,
    this.usuario_mrn,
    this.producto_venta,
    this.producto,
    this.valor,
    this.celular,
    this.canal_transaccion = '2',
    this.transaccion_externa = '0',
    this.documento = '1088310088',
    this.oficina,
    this.matricul,
    this.emai,
    this.recargas_multiproducto = '1',
    this.token,
    this.nombr,
    this.cod_municipio,
    this.cant_sorteos = '0',
    this.cant_cartones = '0',
    this.bolsa_ganancia,
    this.venta_ganancias = false,
    this.medioVenta = 'Movil',
    this.tipo_datos = 'Propios',
    this.tipo_red = 'Wifi',
    this.app_ver = '3',
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nodo'] = nodo;
    data['usuario_mrn'] = usuario_mrn;
    data['producto_venta'] = producto_venta;
    data['producto'] = producto;
    data['valor'] = valor;
    data['celular'] = celular;
    data['canal_transaccion'] = canal_transaccion;
    data['transaccion_externa'] = transaccion_externa;
    data['documento'] = documento;
    data['oficina'] = oficina;
    data['matricula'] = matricul;
    data['email'] = emai;
    data['recargas_multiproducto'] = recargas_multiproducto;
    data['token'] = token;
    data['nombre'] = nombr;
    data['cod_municipio'] = cod_municipio;
    data['cant_sorteos'] = cant_sorteos;
    data['cant_cartones'] = cant_cartones;
    data['bolsa_ganancia'] = bolsa_ganancia;
    data['venta_ganancias'] = venta_ganancias;
    data['medioVenta'] = medioVenta = 'Movil';
    data['tipo_datos'] = tipo_datos = 'Propios';
    data['tipo_red'] = tipo_red = 'Wifi';
    data['app_ver'] = app_ver;
    return data;
  }
}