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

  UsuarioActual({
    this.id,
    this.password,
    this.token,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.nodoId,
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
    return data;
  }
}