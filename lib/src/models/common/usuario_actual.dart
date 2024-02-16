import 'dart:core';

class UsuarioActual {
  int? id;
  String? password;
  String? token;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  int? nodoId;
  String? tipo_nodo;
  String? telefono;
  String? cargo;

  UsuarioActual({
    this.id,
    this.password,
    this.token,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.nodoId,
    this.tipo_nodo,
    this.telefono,
    this.cargo,
  });

  UsuarioActual.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    token = json['token'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    nodoId = json['nodo_id'];
    tipo_nodo = json['tipo_nodo'];
    telefono = json['telefono'];
    cargo = json['cargo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['password'] = password;
    data['token'] = token;
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['nodo_id'] = nodoId;
    data['tipo_nodo'] = tipo_nodo;
    data['telefono'] = telefono;
    data['telefono'] = telefono;
    return data;
  }
}