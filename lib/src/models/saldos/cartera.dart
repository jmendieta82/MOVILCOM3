

class Cartera {
  int?id;
  int?nodo;
  int?valor;
  String?fecha_aprobacion;
  String?estadoPago;
  String?fecha_pago;
  String?representanteLegal;
  int?saldo_pendiente_pago;
  bool seleccionado = false;



  Cartera({
    this.id,
    this.nodo,
    this.valor,
    this.fecha_aprobacion,
    this.estadoPago,
    this.fecha_pago,
    this.representanteLegal,
    this.saldo_pendiente_pago,
    this.seleccionado = false,
  });

  Cartera.fromJson(Map<String, dynamic> json){
    id= json["id"];
    nodo= json["nodo"];
    valor= json["valor"];
    fecha_aprobacion= json["fecha_aprobacion"];
    estadoPago= json["estadoPago"];
    fecha_pago= json["fecha_pago"];
    representanteLegal= json["representanteLegal"];
    saldo_pendiente_pago= json["saldo_pendiente_pago"];
    seleccionado= false;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "nodo":nodo,
    "valor": valor,
    "fecha_aprobacion": fecha_aprobacion,
    "estadoPago": estadoPago,
    "fecha_pago":fecha_pago,
    "representanteLegal": representanteLegal,
    "saldo_pendiente_pago": saldo_pendiente_pago,
    "seleccionado": seleccionado,
  };
}

