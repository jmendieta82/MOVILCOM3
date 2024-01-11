class ReportePagos {
  int? id;
  int? transaccion;
  String? usuario;
  String? novedad;
  int? abono;
  int? valor;
  int? saldo_pendiente;
  String? numero_recibo;
  String? soporte;
  String? entidad;
  String? created_at;
  String? estadoPago;
  String? motivo_rechazo;

  ReportePagos({
    this.id,
    this.transaccion,
    this.usuario,
    this.novedad,
    this.abono,
    this.valor,
    this.saldo_pendiente,
    this.numero_recibo,
    this.soporte,
    this.entidad,
    this.created_at,
    this.estadoPago,
    this.motivo_rechazo,
  });

  ReportePagos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transaccion= json['transaccion'];
    usuario = json['usuario'];
    novedad = json['novedad'];
    abono = json['abono'];
    valor = json['valor'];
    saldo_pendiente = json['saldo_pendiente'];
    numero_recibo = json['numero_recibo'];
    soporte = json['soporte'];
    entidad = json['entidad'];
    created_at = json['created_at'];
    estadoPago = json['estadoPago'];
    motivo_rechazo = json['motivo_rechazo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['transaccion'] = transaccion;
    data['usuario'] = usuario;
    data['novedad'] = novedad;
    data['abono'] = abono;
    data['valor'] = valor;
    data['saldo_pendiente'] = saldo_pendiente;
    data['numero_recibo'] = numero_recibo;
    data['soporte'] = soporte;
    data['entidad'] = entidad;
    data['created_at'] = created_at;
    data['estadoPago'] = estadoPago;
    data['motivo_rechazo'] = motivo_rechazo;
    return data;
  }
}