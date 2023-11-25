import 'dio/dio_client.dart';
import 'dio/paths.dart';
import 'package:movilcomercios/src/models/paquetes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class PaquetesApiConnection{

  Future<List<Paquetes>> getPaquetesList() async {
    final response = await DioClient.instance.get(paquetes);
    return (response).map((e) => Paquetes.fromJson(e)).toList();

  }
}

final paquetesProvider =  Provider<PaquetesApiConnection>((ref)  => PaquetesApiConnection());