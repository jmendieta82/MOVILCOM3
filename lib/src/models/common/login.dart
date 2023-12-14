class Login {
  String? username;
  String? password;

  Login({this.username, this.password});

  Login.fromJson(Map<String, dynamic> json) {
    username = json['id'];
    password = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}