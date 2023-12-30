

class UltimasSolicitudes {
  int?id;
  String?fecha_aprobacion;
  String?tipo_transaccion;
  String?hora_aprobacion;
  String?created_at;
  String?tipoServicio;
  String?estado;
  int?valor;
  String?estadoPago;


  UltimasSolicitudes({
    this.id,
    this.fecha_aprobacion,
    this.tipo_transaccion,
    this.hora_aprobacion,
    this.created_at,
    this.tipoServicio,
    this.estado,
    this.valor,
    this.estadoPago,
  });

  UltimasSolicitudes.fromJson(Map<String, dynamic> json){
    id= json["id"];
    fecha_aprobacion= json["fecha_aprobacion"];
    tipo_transaccion= json["tipo_transaccion"]=='SSC'?'Contado':'Credito';
    hora_aprobacion= json["hora_aprobacion"];
    created_at= json["created_at"];
    tipoServicio= json["tipoServicio"] == 'CV'?'Comision por venta':'Comision anticipada';
    estado= json["estado"];
    valor= json["valor"];
    estadoPago= json["estadoPago"];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "fecha_aprobacion":fecha_aprobacion,
    "tipo_transaccion": tipo_transaccion,
    "hora_aprobacion": hora_aprobacion,
    "created_at": created_at,
    "tipoServicio":tipoServicio,
    "estado": estado,
    "valor": valor,
    "estadoPago": estadoPago,
  };
}

