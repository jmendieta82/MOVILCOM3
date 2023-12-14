

class UltimasVentas {
  int? id;
  String? referenciaPago;
  String? codigoTransaccionExterna;
  String? ventaDesde;
  String? nomEmpresa;
  String? convenioPago;
  String? ultimoSaldo;
  int? valor;
  String? saldoActual;
  String? ganancia;
  String? numeroDestino;
  String? codigoResultado;
  String? resultado;
  String? soporte;
  String? nomProducto;
  String? createdAt;
  String? hourAt;
  String? ultimo_saldo_ganancias;
  String? saldo_actual_ganancias;
  bool? imprime;



  UltimasVentas({
    this.id,
    this.referenciaPago,
    this.codigoTransaccionExterna,
    this.ventaDesde,
    this.nomEmpresa,
    this.convenioPago,
    this.ultimoSaldo,
    this.valor,
    this.saldoActual,
    this.ganancia,
    this.numeroDestino,
    this.codigoResultado,
    this.resultado,
    this.soporte,
    this.nomProducto,
    this.createdAt,
    this.hourAt,
    this.ultimo_saldo_ganancias,
    this.saldo_actual_ganancias,
    this.imprime,
  });


  UltimasVentas.fromJson(Map<String, dynamic> json){
    id= json["id"];
    referenciaPago= json["referencia_pago"];
    codigoTransaccionExterna= json["codigo_transaccion_externa"];
    ventaDesde= json["venta_desde"];
    nomEmpresa= json["nom_empresa"];
    convenioPago= json["convenio_pago"];
    ultimoSaldo= json["ultimoSaldo"];
    valor= json["valor"];
    saldoActual= json["saldo_actual"];
    ganancia= json["ganancia"];
    numeroDestino= json["numeroDestino"];
    codigoResultado= json["codigo_resultado"];
    resultado= json["resultado"];
    soporte= json["soporte"];
    nomProducto= json["nom_producto"];
    createdAt= json["created_at"];
    hourAt= json["hour_at"];
    ultimo_saldo_ganancias= json["ultimo_saldo_ganancias"];
    ultimo_saldo_ganancias= json["saldo_actual_ganancias"];
    imprime= json["imprime"];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "referencia_pago":referenciaPago,
    "codigo_transaccion_externa": codigoTransaccionExterna,
    "venta_desde": ventaDesde,
    "nom_empresa": nomEmpresa,
    "convenio_pago":convenioPago,
    "ultimoSaldo": ultimoSaldo,
    "valor": valor,
    "saldo_actual": saldoActual,
    "ganancia": ganancia,
    "numeroDestino": numeroDestino,
    "codigo_resultado": codigoResultado,
    "resultado": resultado,
    "soporte": soporte,
    "nom_producto": nomProducto,
    "created_at": createdAt,
    "ultimo_saldo_ganancias": ultimo_saldo_ganancias,
    "saldo_actual_ganancias": saldo_actual_ganancias,
    "hour_at": hourAt,
    "imprime": imprime
  };
}

