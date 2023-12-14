class Transaccion{
  int? id;
  String? nodo;
  String? numeroDestino;
  String? created_at;
  int? valor;
  String? resultado;
  String? estado;
  String? nombre_empresa;
  String? representante_legal;
  String? medioVenta;
  String? ultimoSaldo;
  String? saldo_actual;
  String? codigo_transaccion_externa;
  String? hour_at;
  int? codigo_producto;
  String? nom_producto;
  String? proveedor;
  String? codigo_resultado;
  String? tipo_red;
  String? tipo_datos;
  String? tiempo_respuesta;
  String? ganancia;
  String? observacion;
  String? app_ver;
  String? referencia_pago;
  String? convenio_pago;

  Transaccion({
    this.id,
    this.nodo,
    this.numeroDestino,
    this.created_at,
    this.valor,
    this.resultado,
    this.estado,
    this.nombre_empresa,
    this.representante_legal,
    this.medioVenta,
    this.ultimoSaldo,
    this.saldo_actual,
    this.codigo_transaccion_externa,
    this.hour_at,
    this.codigo_producto,
    this.nom_producto,
    this.proveedor,
    this.codigo_resultado,
    this.tipo_red,
    this.tipo_datos,
    this.tiempo_respuesta,
    this.ganancia,
    this.observacion,
    this.app_ver,
    this.referencia_pago,
    this.convenio_pago
});

  Transaccion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nodo = json['nodo'];
    numeroDestino = json['numeroDestino'];
    created_at = json['created_at'];
    valor = json['valor'];
    resultado = json['resultado'];
    estado = json['estado'];
    nombre_empresa = json['nombre_empresa'];
    representante_legal = json['representante_legal'];
    medioVenta = json['medioVenta'];
    ultimoSaldo = json['ultimoSaldo'];
    saldo_actual = json['saldo_actual'];
    codigo_transaccion_externa = json['codigo_transaccion_externa'];
    hour_at = json['hour_at'];
    codigo_producto = json['codigo_producto'];
    nom_producto = json['nom_producto'];
    proveedor = json['proveedor'];
    codigo_resultado = json['codigo_resultado'];
    tipo_red = json['tipo_red'];
    tipo_datos = json['tipo_datos'];
    tiempo_respuesta = json['tiempo_respuesta'];
    ganancia = json['ganancia'];
    observacion = json['observacion'];
    app_ver = json['app_ver'];
    referencia_pago = json['referencia_pago'];
    convenio_pago = json['convenio_pag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> transJsonData = <String, dynamic>{};
    transJsonData['id']=id;
    transJsonData['nodo']=nodo;
    transJsonData['numeroDestino']=numeroDestino;
    transJsonData['created_at']=created_at;
    transJsonData['valor']=valor;
    transJsonData['resultado']=resultado;
    transJsonData['estado']=estado;
    transJsonData['nombre_empresa']=nombre_empresa;
    transJsonData['representante_legal']=representante_legal;
    transJsonData['medioVenta']=medioVenta;
    transJsonData['ultimoSaldo']=ultimoSaldo;
    transJsonData['saldo_actual']=saldo_actual;
    transJsonData['codigo_transaccion_externa']=codigo_transaccion_externa;
    transJsonData['hour_at']=hour_at;
    transJsonData['codigo_producto']=codigo_producto;
    transJsonData['nom_producto']=nom_producto;
    transJsonData['proveedor']=proveedor;
    transJsonData['codigo_resultado']=codigo_resultado;
    transJsonData['tipo_red']=tipo_red;
    transJsonData['tipo_datos']=tipo_datos;
    transJsonData['tiempo_respuesta']=tiempo_respuesta;
    transJsonData['ganancia']=ganancia;
    transJsonData['observacion']=observacion;
    transJsonData['app_ver']=app_ver;
    transJsonData['referencia_pago']=referencia_pago;
    transJsonData['convenio_pago']=convenio_pago;
    return transJsonData;
  }
}