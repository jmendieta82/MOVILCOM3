class FacturaReacudo {
  String? reply;
  String? estado;
  String? referencia;
  String? nconvenio;
  dynamic valorPago;
  String? idPre;
  int? pagoParcial;

  FacturaReacudo({
    this.reply,
    this.estado,
    this.referencia,
    this.nconvenio,
    this.valorPago,
    this.idPre,
    this.pagoParcial,
  });

  FacturaReacudo.fromJson(Map<String, dynamic> json) {
    reply = json['reply'];
    estado = json['estado'];
    referencia = json['referencia'];
    nconvenio = json['nconvenio'];
    valorPago = json['valorPago'];
    idPre = json['idPre'];
    pagoParcial = json['pagoParcial'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reply'] = reply;
    data['estado'] = estado;
    data['referencia'] = referencia;
    data['nconvenio'] = nconvenio;
    data['valorPago'] = valorPago;
    data['idPre'] = idPre;
    data['pagoParcial'] = pagoParcial;
    return data;
  }
}